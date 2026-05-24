import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = path.resolve(__dirname, '..');

const MASTER_PLAN = path.join(
  ROOT,
  'docs',
  '02_FLUTTER_MIGRATION',
  'Flutter-Port-Master-Plan.md',
);
const FLUTTER_FEATURES_ROOT = path.join(ROOT, 'flutter_app', 'lib', 'features');
const HOME_MOCK_DATA = path.join(
  ROOT,
  'flutter_app',
  'lib',
  'features',
  'home',
  'data',
  'home_mock_data.dart',
);
const VIT_BOTTOM_NAV = path.join(
  ROOT,
  'flutter_app',
  'lib',
  'shared',
  'layout',
  'vit_bottom_nav.dart',
);
const VIT_APP_SHELL = path.join(
  ROOT,
  'flutter_app',
  'lib',
  'shared',
  'layout',
  'vit_app_shell.dart',
);
const OUTPUT_DIR = path.join(
  ROOT,
  'output',
  'flutter-ui-reference',
  'flutter-candidates',
  'audits',
);

const OUTPUT_FILES = {
  markdown: path.join(OUTPUT_DIR, 'migrated-home-standard-audit.md'),
  csv: path.join(OUTPUT_DIR, 'migrated-home-standard-audit.csv'),
  json: path.join(OUTPUT_DIR, 'migrated-home-standard-audit.json'),
};

const PAGE_ALIASES = new Map([
  ['txhistorypage', 'transactionhistorypage'],
  ['copytradingpagev2', 'copytradingv2page'],
]);

const RULES = [
  {
    id: 'legacyBlue',
    label: 'Legacy blue/local brand',
    grade: 'FAIL_BRAND',
    pattern:
      /0xFF3B82F6|0x[0-9A-Fa-f]*3B82F6|60A5FA|2563EB|1D4ED8|Colors\.blue\b|blueAccent\b|_\w*Blue\b/g,
  },
  {
    id: 'legacySurface',
    label: 'Legacy/local surface palette',
    grade: 'FAIL_SURFACE',
    pattern:
      /0xFF080C14|0xFF151A23|0xFF1D2436|0xFF1D263B|0xFF121721|0xFF152655|0xFF101936|_\w*(?:Bg|Surface|Surface2|ChipBg|PanelBg|CardBg)\b/g,
  },
  {
    id: 'localDarkSurfacePalette',
    label: 'Local dark card/surface palette',
    grade: 'FAIL_SURFACE',
    pattern: /(?:const\s+)?Color\(0xFF[0-9A-Fa-f]{6}\)/g,
  },
  {
    id: 'hardcodedControlHeight',
    label: 'Hardcoded control height',
    grade: 'REVIEW_SIZE',
    pattern: /(?:height|minHeight|rowHeight):\s*(?:48|50|56|60|72)\b/g,
  },
  {
    id: 'directRadius',
    label: 'Direct repeated radius',
    grade: 'REVIEW_SIZE',
    pattern: /BorderRadius\.circular\((?:1[0-9]|2[0-9]|3[0-9])(?:\.0)?\)/g,
  },
];

const RISK_ORDER = [
  'BLOCKED_UNMAPPED',
  'FAIL_BRAND',
  'FAIL_SURFACE',
  'REVIEW_SIZE',
  'REVIEW_LAYOUT',
  'PASS',
];

async function main() {
  const migratedRows = await parseMigratedRows();
  const presentationFiles = await listDartFiles(FLUTTER_FEATURES_ROOT);
  await primeFileCache(presentationFiles);
  const classIndex = buildClassIndex(presentationFiles);
  const globalIdentityFindings = await getGlobalIdentityFindings();

  const auditedRows = migratedRows.map((row) =>
    auditRow(row, classIndex, globalIdentityFindings),
  );
  const uniqueFiles = [...new Set(auditedRows.map((row) => row.file).filter(Boolean))];
  const moduleSummary = summarizeByModule(auditedRows);
  const riskSummary = summarizeByRisk(auditedRows);
  const identitySummary = summarizeByIdentity(auditedRows);
  const identityGates = {
    ...globalIdentityFindings.summary,
    moduleLocalGradient: auditedRows.reduce(
      (total, row) => total + (row.counts?.moduleLocalGradient ?? 0),
      0,
    ),
  };
  const topRiskFiles = summarizeTopFiles(auditedRows);

  const report = {
    generatedAt: new Date().toISOString(),
    source: {
      masterPlan: relativePath(MASTER_PLAN),
      standard: 'docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md',
      homeReference:
        'docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md',
    },
    scope: {
      migratedRows: migratedRows.length,
      uniquePresentationFiles: uniqueFiles.length,
      unmappedRows: auditedRows.filter((row) => row.riskGrade === 'BLOCKED_UNMAPPED')
        .length,
      firstSc: migratedRows[0]?.sc ?? '',
      lastSc: migratedRows.at(-1)?.sc ?? '',
    },
    rules: RULES.map(({ id, label, grade }) => ({ id, label, grade })),
    aliases: Object.fromEntries(PAGE_ALIASES),
    moduleSummary,
    riskSummary,
    identitySummary,
    identityGates,
    topRiskFiles,
    rows: auditedRows,
  };

  await fs.mkdir(OUTPUT_DIR, { recursive: true });
  await fs.writeFile(OUTPUT_FILES.json, `${JSON.stringify(report, null, 2)}\n`);
  await fs.writeFile(OUTPUT_FILES.csv, toCsv(auditedRows));
  await fs.writeFile(OUTPUT_FILES.markdown, toMarkdown(report));

  printSummary(report);
}

async function parseMigratedRows() {
  const source = await fs.readFile(MASTER_PLAN, 'utf8');
  const rows = [];

  for (const line of source.split(/\r?\n/)) {
    if (!line.startsWith('| SC-')) continue;
    const cols = line.split('|').map((col) => col.trim());
    if (cols.length < 10) continue;

    const [sc, order, page, route] = [cols[1], cols[2], cols[3], cols[4]];
    const [ui, contract, qa] = [cols[7], cols[8], cols[9]];
    if (!hasCheckedBox(ui) || !hasCheckedBox(contract) || !hasCheckedBox(qa)) {
      continue;
    }

    rows.push({
      sc,
      order: Number(order),
      page,
      route,
      uiStatus: ui,
      contractStatus: contract,
      qaStatus: qa,
    });
  }

  return rows;
}

function hasCheckedBox(text) {
  return /\[x\]/i.test(text);
}

async function listDartFiles(root) {
  const files = [];

  async function walk(dir) {
    const entries = await fs.readdir(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        await walk(fullPath);
      } else if (
        entry.isFile() &&
        entry.name.endsWith('.dart') &&
        fullPath.includes(`${path.sep}presentation${path.sep}`)
      ) {
        files.push(fullPath);
      }
    }
  }

  await walk(root);
  return files.sort();
}

function buildClassIndex(files) {
  const index = new Map();
  const duplicates = new Map();

  for (const file of files) {
    const source = readFileSyncCached(file);
    const classPattern = /^class\s+([A-Za-z][A-Za-z0-9]*)\b/gm;
    for (const match of source.matchAll(classPattern)) {
      const className = match[1];
      if (className.startsWith('_')) continue;

      const key = className.toLowerCase();
      if (index.has(key)) {
        duplicates.set(key, [index.get(key), file]);
      } else {
        index.set(key, file);
      }
    }
  }

  if (duplicates.size > 0) {
    const duplicateText = [...duplicates.entries()]
      .map(
        ([key, filesForClass]) =>
          `${key}: ${filesForClass.map((file) => relativePath(file)).join(', ')}`,
      )
      .join('\n');
    throw new Error(`Duplicate public page class mappings found:\n${duplicateText}`);
  }

  return index;
}

function auditRow(row, classIndex, globalIdentityFindings) {
  const lookupKey = PAGE_ALIASES.get(row.page.toLowerCase()) ?? row.page.toLowerCase();
  const file = classIndex.get(lookupKey);

  if (!file) {
    return {
      ...row,
      module: moduleFromRoute(row.route),
      file: '',
      riskGrade: 'BLOCKED_UNMAPPED',
      visualCaptureStatus: 'BLOCKED_UNMAPPED',
      flags: ['BLOCKED_UNMAPPED'],
      counts: emptyCounts(),
      samples: {},
      identityStatus: 'NEEDS_IDENTITY_REVIEW',
      identityFlags: ['BLOCKED_UNMAPPED'],
    };
  }

  const source = readFileSyncCached(file);
  const findings = Object.fromEntries(
    RULES.map((rule) => [
      rule.id,
      rule.id === 'hardcodedControlHeight'
        ? findControlHeightHits(source, rule.pattern)
        : rule.id === 'localDarkSurfacePalette'
          ? findLocalDarkSurfaceHits(source, rule.pattern)
        : findRuleHits(source, rule.pattern),
    ]),
  );

  const layoutInfo = getLayoutInfo(source);
  const layoutFlags = [];
  if (!layoutInfo.usesVitPageLayout) layoutFlags.push('missingVitPageLayout');
  if (!layoutInfo.usesVitPageContent && !layoutInfo.hasAcceptedCustomScrollLayout) {
    layoutFlags.push('missingVitPageContent');
  }
  if (layoutInfo.usesCustomScaffold) layoutFlags.push('usesCustomScaffold');

  const counts = {
    legacyBlue: findings.legacyBlue.length,
    legacySurface: findings.legacySurface.length,
    localDarkSurfacePalette: findings.localDarkSurfacePalette.length,
    hardcodedControlHeight: findings.hardcodedControlHeight.length,
    directRadius: findings.directRadius.length,
    layout: layoutFlags.length,
    primaryActionEmojiIcons:
      row.page === 'HomePage'
        ? globalIdentityFindings.quickActionEmojiIcons.length
        : 0,
    bottomNavModuleAccent: globalIdentityFindings.bottomNavModuleAccent.length,
    moduleLocalGradient: findLocalModuleGradientHits(source).length,
  };
  const identityFindings = {
    primaryActionEmojiIcons:
      row.page === 'HomePage' ? globalIdentityFindings.quickActionEmojiIcons : [],
    bottomNavModuleAccent: globalIdentityFindings.bottomNavModuleAccent,
    moduleLocalGradient: findLocalModuleGradientHits(source),
  };

  const flags = [];
  if (counts.legacyBlue > 0) flags.push('FAIL_BRAND');
  if (counts.legacySurface > 0 || counts.localDarkSurfacePalette > 0) {
    flags.push('FAIL_SURFACE');
  }
  if (counts.hardcodedControlHeight > 0 || counts.directRadius > 0) {
    flags.push('REVIEW_SIZE');
  }
  if (counts.layout > 0) flags.push('REVIEW_LAYOUT');

  const riskGrade = pickRiskGrade(flags);
  const identityStatus = pickIdentityStatus(source, counts);
  const identityFlags = identityStatus === 'NEEDS_IDENTITY_REVIEW'
    ? [
        ...(counts.primaryActionEmojiIcons > 0 ? ['PRIMARY_ACTION_EMOJI_ICON'] : []),
        ...(counts.bottomNavModuleAccent > 0 ? ['BOTTOM_NAV_MODULE_ACCENT'] : []),
        ...(counts.moduleLocalGradient > 0 ? ['MODULE_LOCAL_GRADIENT'] : []),
      ]
    : [identityStatus];
  return {
    ...row,
    module: moduleFromFile(file),
    file: relativePath(file),
    riskGrade,
    visualCaptureStatus:
      riskGrade !== 'PASS'
        ? 'DEFERRED_STATIC_FAIL'
        : identityStatus === 'NEEDS_IDENTITY_REVIEW'
          ? 'DEFERRED_IDENTITY_REVIEW'
          : 'READY_FOR_VISUAL_AUDIT',
    flags: flags.length > 0 ? flags : ['PASS'],
    identityStatus,
    identityFlags,
    counts,
    layoutFlags,
    layoutInfo,
    samples: {
      legacyBlue: toSamples(findings.legacyBlue),
      legacySurface: toSamples(findings.legacySurface),
      localDarkSurfacePalette: toSamples(findings.localDarkSurfacePalette),
      hardcodedControlHeight: toSamples(findings.hardcodedControlHeight),
      directRadius: toSamples(findings.directRadius),
      primaryActionEmojiIcons: toSamples(identityFindings.primaryActionEmojiIcons),
      bottomNavModuleAccent: toSamples(identityFindings.bottomNavModuleAccent),
      moduleLocalGradient: toSamples(identityFindings.moduleLocalGradient),
    },
  };
}

const fileCache = new Map();

function readFileSyncCached(file) {
  if (!fileCache.has(file)) {
    throw new Error(
      `Internal error: ${relativePath(file)} was requested before it was cached.`,
    );
  }
  return fileCache.get(file);
}

function findRuleHits(source, pattern) {
  const hits = [];
  const lineStarts = computeLineStarts(source);

  pattern.lastIndex = 0;
  for (const match of source.matchAll(pattern)) {
    const index = match.index ?? 0;
    const line = lineForIndex(lineStarts, index);
    hits.push({
      line,
      match: match[0],
      snippet: sourceLine(source, line),
    });
  }

  return hits;
}

function findControlHeightHits(source, pattern) {
  return findRuleHits(source, pattern).filter((hit) =>
    isLikelyControlHeightHit(source, hit),
  );
}

function findLocalDarkSurfaceHits(source, pattern) {
  return findRuleHits(source, pattern).filter((hit) =>
    isLikelyLocalDarkSurfaceHit(source, hit),
  );
}

async function getGlobalIdentityFindings() {
  const [homeData, bottomNav, appShell] = await Promise.all([
    readOptionalText(HOME_MOCK_DATA),
    readOptionalText(VIT_BOTTOM_NAV),
    readOptionalText(VIT_APP_SHELL),
  ]);

  const quickActionEmojiIcons = findQuickActionEmojiIconHits(homeData);
  const bottomNavModuleAccent = findBottomNavModuleAccentHits(`${bottomNav}\n${appShell}`);

  return {
    quickActionEmojiIcons,
    bottomNavModuleAccent,
    summary: {
      primaryActionEmojiIcons: quickActionEmojiIcons.length,
      bottomNavModuleAccent: bottomNavModuleAccent.length,
    },
  };
}

async function readOptionalText(file) {
  try {
    return await fs.readFile(file, 'utf8');
  } catch {
    return '';
  }
}

function findQuickActionEmojiIconHits(source) {
  return findRuleHits(source, /HomeQuickAction\(\s*icon:\s*['"][^'"]+['"]/g);
}

function findBottomNavModuleAccentHits(source) {
  return findRuleHits(source, /\baccentColor\b/g).filter((hit) => {
    const context = sourceWindow(source, hit.line, 4);
    return /\bVitBottomNav\b|_bottomNavAccentForPath|activeColor|activeDark|activeShadow/.test(
      context,
    );
  });
}

function findLocalModuleGradientHits(source) {
  return findRuleHits(source, /(?:const\s+)?Color\(0x[0-9A-Fa-f]{8}\)/g).filter(
    (hit) => {
      const context = sourceWindow(source, hit.line, 8);
      if (!/\b(?:LinearGradient|RadialGradient|SweepGradient|colors:\s*\[)/.test(context)) {
        return false;
      }
      return /\b(?:BoxDecoration|VitCard|Hero|hero|Card|card|background|surface|panel|Container)\b/.test(
        context,
      );
    },
  );
}

function isLikelyLocalDarkSurfaceHit(source, hit) {
  const hex = hit.match.match(/0xFF([0-9A-Fa-f]{6})/)?.[1]?.toUpperCase();
  if (!hex || !isDarkColorHex(hex)) return false;

  const context = sourceWindow(source, hit.line, 5);
  const wideContext = sourceWindow(source, hit.line, 12);
  const localName =
    context.match(
      /\b(?:const|final)\s+(_[A-Za-z0-9_]+)\s*=\s*(?:const\s+)?Color\(0xFF[0-9A-Fa-f]{6}\)/,
    )?.[1] ?? '';

  if (isQrOrPainterOnlyContext(wideContext)) {
    return false;
  }
  if (isAllowedSemanticColorName(localName)) return false;

  return isSurfaceLikeName(localName) || isSurfaceLikeColorContext(context, hit.snippet);
}

function isDarkColorHex(hex) {
  const value = Number.parseInt(hex, 16);
  const red = (value >> 16) & 255;
  const green = (value >> 8) & 255;
  const blue = value & 255;
  return red <= 100 && green <= 112 && blue <= 135;
}

function isSurfaceLikeName(name) {
  return /\b[A-Za-z0-9_]*(?:Background|Bg|Panel|Card|Hero|Field|Footer|Tabs?|Toolbar|Border|Stroke|Divider|Chip|Pill|Segment|Inactive|Input|Overlay|Container|Box|Rate|Disabled|Option|Track|Filter|Sheet)[A-Za-z0-9_]*\b/.test(
    name,
  );
}

function isAllowedSemanticColorName(name) {
  return /\b[A-Za-z0-9_]*(?:Green|Red|Amber|Orange|Purple|Cyan|Muted|Gray|Grey|White|Black|Gold|Silver|Bronze|Buy|Sell|Warning|Warn|Danger|Success|Error|Rank|Tier|Token|Logo|Coin|Category|Share|Twitter|Facebook|Positive|Negative)[A-Za-z0-9_]*\b/.test(
    name,
  );
}

function isQrOrPainterOnlyContext(context) {
  return /\b(?:_QrPainter|QrPainter|QRCode|qrCode|qr|CustomPainter|CustomPaint|Canvas|canvas\.drawRect|Rect\.fromLTWH|PaintingStyle|Paint\(\)\.\.color|finder)\b/.test(
    context,
  );
}

function isSurfaceLikeColorContext(context, line) {
  if (/\b(?:background|backgroundColor|barrierColor|shadowColor|trackColor):/.test(line)) {
    return true;
  }
  if (/\b(?:Border\.all|BorderSide|side:|border:)\b/.test(context)) return true;
  if (/\b(?:LinearGradient|RadialGradient|SweepGradient|colors:\s*\[)\b/.test(context)) {
    return true;
  }
  if (/\b(?:LinearProgressIndicator|CircularProgressIndicator|Progress|Track)\b/.test(context)) {
    return true;
  }
  const isColorValueLine = /\bcolor:/.test(line) || /[?:]\s*(?:const\s+)?Color\(/.test(line);
  if (!isColorValueLine) return false;

  if (/\b(?:TextStyle|copyWith|Icon\(|IconData|valueColor|AlwaysStoppedAnimation)\b/.test(context)) {
    return false;
  }

  return /\b(?:BoxDecoration|ShapeDecoration|Container|DecoratedBox|ColoredBox|Material|Ink|Card|VitCard|Segment|Chip|Pill|Button|Tab|Input|Field|Tile|Panel|Hero|Footer|Toolbar|Sheet)\b/.test(
    context,
  );
}

function isLikelyControlHeightHit(source, hit) {
  const line = hit.snippet;
  if (/\bSizedBox\s*\(/.test(line)) return false;
  if (/\b(?:rowHeight|minHeight):/.test(line)) return hasControlContext(source, hit.line);

  return hasControlContext(source, hit.line) && !hasNonControlHeightContext(source, hit.line);
}

function hasControlContext(source, lineNumber) {
  const context = sourceWindow(source, lineNumber, 12);
  return /\b(?:Button|button|CTA|Cta|Input|TextField|TextFormField|Field|Search|Segment|Tab|Tabs|Chip|Pill|Switch|Toggle|InkWell|GestureDetector|TextButton|ElevatedButton|OutlinedButton|FilledButton|Dropdown)\b/.test(
    context,
  );
}

function hasNonControlHeightContext(source, lineNumber) {
  const context = sourceWindow(source, lineNumber, 8);
  return /\b(?:StatBox|StatsSummary|Chart|chart|Spark|spark|Avatar|avatar|IconTile|iconBox|Logo|logo|Image|image|Thumbnail|thumbnail|Illustration|illustration|Skeleton|skeleton|Divider|divider|Progress|progress|Meter|meter|Metric|metric|CardHeader|HeroIcon)\b/.test(
    context,
  );
}

function getLayoutInfo(source) {
  const usesVitPageLayout = /\bVitPageLayout\b/.test(source);
  const usesVitPageContent = /\bVitPageContent\b/.test(source);
  const usesCustomScrollLayout =
    /\b(?:SingleChildScrollView|CustomScrollView|ListView|Scrollable|PageView)\b/.test(
      source,
    );
  const usesSharedSizing = /\b(?:AppSpacing|DeviceMetrics)\b/.test(source);
  const usesCustomScaffold = /\bScaffold\s*\(/.test(source);

  return {
    usesVitPageLayout,
    usesVitPageContent,
    usesCustomScrollLayout,
    usesSharedSizing,
    usesCustomScaffold,
    hasAcceptedCustomScrollLayout:
      usesVitPageLayout && usesCustomScrollLayout && usesSharedSizing && !usesCustomScaffold,
  };
}

function sourceWindow(source, lineNumber, radius) {
  const lines = source.split(/\r?\n/);
  const start = Math.max(0, lineNumber - radius - 1);
  const end = Math.min(lines.length, lineNumber + radius);
  return lines.slice(start, end).join('\n');
}

function computeLineStarts(source) {
  const starts = [0];
  for (let i = 0; i < source.length; i += 1) {
    if (source[i] === '\n') starts.push(i + 1);
  }
  return starts;
}

function lineForIndex(lineStarts, index) {
  let low = 0;
  let high = lineStarts.length - 1;
  while (low <= high) {
    const mid = Math.floor((low + high) / 2);
    if (lineStarts[mid] <= index) low = mid + 1;
    else high = mid - 1;
  }
  return high + 1;
}

function sourceLine(source, lineNumber) {
  return source.split(/\r?\n/)[lineNumber - 1]?.trim() ?? '';
}

function toSamples(hits) {
  return hits.slice(0, 5).map((hit) => ({
    line: hit.line,
    match: hit.match,
    snippet: hit.snippet,
  }));
}

function pickRiskGrade(flags) {
  if (flags.length === 0) return 'PASS';
  for (const grade of RISK_ORDER) {
    if (flags.includes(grade)) return grade;
  }
  return flags[0];
}

function pickIdentityStatus(source, counts) {
  if (
    counts.primaryActionEmojiIcons > 0 ||
    counts.bottomNavModuleAccent > 0 ||
    counts.moduleLocalGradient > 0
  ) {
    return 'NEEDS_IDENTITY_REVIEW';
  }

  if (/\b(?:AppModuleAccents|VitServiceTile|VitModuleHeroCard|VitMetricCard|VitModuleSectionHeader)\b/.test(source)) {
    return 'MODULE_ACCENT_PASS';
  }

  return 'FOUNDATION_PASS';
}

function emptyCounts() {
  return {
    legacyBlue: 0,
    legacySurface: 0,
    localDarkSurfacePalette: 0,
    hardcodedControlHeight: 0,
    directRadius: 0,
    layout: 0,
    primaryActionEmojiIcons: 0,
    bottomNavModuleAccent: 0,
    moduleLocalGradient: 0,
  };
}

function moduleFromRoute(route) {
  const first = route.split('/').filter(Boolean)[0];
  return first || 'unknown';
}

function moduleFromFile(file) {
  const rel = relativePath(file);
  const match = rel.match(/^flutter_app\/lib\/features\/([^/]+)\//);
  return match?.[1] ?? 'unknown';
}

function summarizeByModule(rows) {
  const map = new Map();
  for (const row of rows) {
    const summary = map.get(row.module) ?? {
      module: row.module,
      screens: 0,
      pass: 0,
      blocked: 0,
      failBrand: 0,
      failSurface: 0,
      reviewSize: 0,
      reviewLayout: 0,
      foundationPass: 0,
      moduleAccentPass: 0,
      needsIdentityReview: 0,
    };
    summary.screens += 1;
    if (row.riskGrade === 'PASS') summary.pass += 1;
    if (row.riskGrade === 'BLOCKED_UNMAPPED') summary.blocked += 1;
    if (row.flags.includes('FAIL_BRAND')) summary.failBrand += 1;
    if (row.flags.includes('FAIL_SURFACE')) summary.failSurface += 1;
    if (row.flags.includes('REVIEW_SIZE')) summary.reviewSize += 1;
    if (row.flags.includes('REVIEW_LAYOUT')) summary.reviewLayout += 1;
    if (row.identityStatus === 'FOUNDATION_PASS') summary.foundationPass += 1;
    if (row.identityStatus === 'MODULE_ACCENT_PASS') summary.moduleAccentPass += 1;
    if (row.identityStatus === 'NEEDS_IDENTITY_REVIEW') {
      summary.needsIdentityReview += 1;
    }
    map.set(row.module, summary);
  }
  return [...map.values()].sort((a, b) => a.module.localeCompare(b.module));
}

function summarizeByRisk(rows) {
  return RISK_ORDER.map((riskGrade) => ({
    riskGrade,
    screens: rows.filter((row) => row.riskGrade === riskGrade).length,
  })).filter((row) => row.screens > 0);
}

function summarizeByIdentity(rows) {
  return ['FOUNDATION_PASS', 'MODULE_ACCENT_PASS', 'NEEDS_IDENTITY_REVIEW']
    .map((identityStatus) => ({
      identityStatus,
      screens: rows.filter((row) => row.identityStatus === identityStatus).length,
    }))
    .filter((row) => row.screens > 0);
}

function summarizeTopFiles(rows) {
  const map = new Map();
  for (const row of rows) {
    if (!row.file) continue;
    const current = map.get(row.file) ?? {
      file: row.file,
      module: row.module,
      screens: 0,
      legacyBlue: 0,
      legacySurface: 0,
      localDarkSurfacePalette: 0,
      hardcodedControlHeight: 0,
      directRadius: 0,
      layout: 0,
      primaryActionEmojiIcons: 0,
      bottomNavModuleAccent: 0,
      moduleLocalGradient: 0,
    };
    current.screens += 1;
    for (const key of Object.keys(row.counts)) {
      current[key] = Math.max(current[key], row.counts[key]);
    }
    map.set(row.file, current);
  }

  return [...map.values()]
    .map((entry) => ({
      ...entry,
      total:
        entry.legacyBlue +
        entry.legacySurface +
        entry.localDarkSurfacePalette +
        entry.hardcodedControlHeight +
        entry.directRadius +
        entry.layout +
        entry.primaryActionEmojiIcons +
        entry.bottomNavModuleAccent +
        entry.moduleLocalGradient,
    }))
    .filter((entry) => entry.total > 0)
    .sort((a, b) => b.total - a.total || a.file.localeCompare(b.file))
    .slice(0, 30);
}

function toCsv(rows) {
  const header = [
    'sc',
    'order',
    'page',
    'route',
    'module',
    'riskGrade',
    'identityStatus',
    'visualCaptureStatus',
    'file',
    'flags',
    'identityFlags',
    'legacyBlue',
    'legacySurface',
    'localDarkSurfacePalette',
    'hardcodedControlHeight',
    'directRadius',
    'layout',
    'primaryActionEmojiIcons',
    'bottomNavModuleAccent',
    'moduleLocalGradient',
    'sampleLines',
  ];

  const lines = [header.join(',')];
  for (const row of rows) {
    const sampleLines = Object.values(row.samples ?? {})
      .flat()
      .map((sample) => sample.line)
      .filter(Boolean)
      .slice(0, 8)
      .join(';');

    lines.push(
      [
        row.sc,
        row.order,
        row.page,
        row.route,
        row.module,
        row.riskGrade,
        row.identityStatus,
        row.visualCaptureStatus,
        row.file,
        row.flags.join(';'),
        row.identityFlags.join(';'),
        row.counts.legacyBlue,
        row.counts.legacySurface,
        row.counts.localDarkSurfacePalette,
        row.counts.hardcodedControlHeight,
        row.counts.directRadius,
        row.counts.layout,
        row.counts.primaryActionEmojiIcons,
        row.counts.bottomNavModuleAccent,
        row.counts.moduleLocalGradient,
        sampleLines,
      ]
        .map(csvEscape)
        .join(','),
    );
  }
  return `${lines.join('\n')}\n`;
}

function toMarkdown(report) {
  const lines = [];
  lines.push('# Migrated Flutter Screens Home Standard Audit');
  lines.push('');
  lines.push(`Generated: \`${report.generatedAt}\``);
  lines.push('');
  lines.push('## Scope');
  lines.push('');
  lines.push(`- Migrated rows: \`${report.scope.migratedRows}\``);
  lines.push(`- Unique presentation files: \`${report.scope.uniquePresentationFiles}\``);
  lines.push(`- Unmapped rows: \`${report.scope.unmappedRows}\``);
  lines.push(`- SC range: \`${report.scope.firstSc}..${report.scope.lastSc}\``);
  lines.push('- Visual capture is deferred for any non-PASS static result.');
  lines.push('');
  lines.push('## Risk Summary');
  lines.push('');
  lines.push('| Risk | Screens |');
  lines.push('| --- | ---: |');
  for (const row of report.riskSummary) {
    lines.push(`| ${row.riskGrade} | ${row.screens} |`);
  }
  lines.push('');
  lines.push('## Module Identity Summary');
  lines.push('');
  lines.push('| Identity status | Screens |');
  lines.push('| --- | ---: |');
  for (const row of report.identitySummary) {
    lines.push(`| ${row.identityStatus} | ${row.screens} |`);
  }
  lines.push('');
  lines.push(
    `- Primary action emoji icons: \`${report.identityGates.primaryActionEmojiIcons}\``,
  );
  lines.push(
    `- Bottom nav module accent hooks: \`${report.identityGates.bottomNavModuleAccent}\``,
  );
  lines.push(
    `- Module-local gradients: \`${report.identityGates.moduleLocalGradient}\``,
  );
  lines.push('');
  lines.push('## Module Summary');
  lines.push('');
  lines.push(
    '| Module | Screens | PASS | Blocked | FAIL_BRAND | FAIL_SURFACE | REVIEW_SIZE | REVIEW_LAYOUT | FOUNDATION_PASS | MODULE_ACCENT_PASS | NEEDS_IDENTITY_REVIEW |',
  );
  lines.push('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |');
  for (const row of report.moduleSummary) {
    lines.push(
      `| ${row.module} | ${row.screens} | ${row.pass} | ${row.blocked} | ${row.failBrand} | ${row.failSurface} | ${row.reviewSize} | ${row.reviewLayout} | ${row.foundationPass} | ${row.moduleAccentPass} | ${row.needsIdentityReview} |`,
    );
  }
  lines.push('');
  lines.push('## Top Flagged Files');
  lines.push('');
  lines.push(
    '| File | Screens | Blue | Surface | Local dark | Height | Radius | Layout | Emoji | Nav accent | Gradient | Total |',
  );
  lines.push('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |');
  if (report.topRiskFiles.length === 0) {
    lines.push('| No flagged files | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |');
  } else {
    for (const row of report.topRiskFiles) {
      lines.push(
        `| ${mdEscape(row.file)} | ${row.screens} | ${row.legacyBlue} | ${row.legacySurface} | ${row.localDarkSurfacePalette} | ${row.hardcodedControlHeight} | ${row.directRadius} | ${row.layout} | ${row.primaryActionEmojiIcons} | ${row.bottomNavModuleAccent} | ${row.moduleLocalGradient} | ${row.total} |`,
      );
    }
  }
  lines.push('');
  lines.push('## Per Screen Results');
  lines.push('');
  lines.push(
    '| SC | Page | Route | Module | Risk | Identity | Visual | File | Flags | Identity flags | Counts | Sample lines |',
  );
  lines.push('| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |');
  for (const row of report.rows) {
    const counts = [
      `blue:${row.counts.legacyBlue}`,
      `surface:${row.counts.legacySurface}`,
      `localDark:${row.counts.localDarkSurfacePalette}`,
      `height:${row.counts.hardcodedControlHeight}`,
      `radius:${row.counts.directRadius}`,
      `layout:${row.counts.layout}`,
      `emoji:${row.counts.primaryActionEmojiIcons}`,
      `navAccent:${row.counts.bottomNavModuleAccent}`,
      `gradient:${row.counts.moduleLocalGradient}`,
    ].join(' ');
    const sampleLines = Object.values(row.samples ?? {})
      .flat()
      .map((sample) => sample.line)
      .filter(Boolean)
      .slice(0, 6)
      .join(', ');
    lines.push(
      `| ${row.sc} | ${mdEscape(row.page)} | \`${row.route}\` | ${row.module} | ${row.riskGrade} | ${row.identityStatus} | ${row.visualCaptureStatus} | ${mdEscape(row.file || 'UNMAPPED')} | ${row.flags.join(', ')} | ${row.identityFlags.join(', ')} | ${counts} | ${sampleLines || '-'} |`,
    );
  }
  lines.push('');
  lines.push('## Audit Rule Notes');
  lines.push('');
  lines.push(
    '- `FAIL_BRAND` flags old React blue/local brand values. These should become `AppColors.primary` or a documented semantic token.',
  );
  lines.push(
    '- `FAIL_SURFACE` flags repeated local dark surfaces. These should become `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, or `borderSolid`.',
  );
  lines.push(
    '- `FAIL_SURFACE` also flags local raw dark card/surface/hero/border/field colors outside semantic state colors. These should use Home-standard `AppColors` tokens.',
  );
  lines.push(
    '- `REVIEW_SIZE` flags direct repeated radii plus hardcoded heights only when the surrounding code is a likely button/input/tab/chip/control context.',
  );
  lines.push(
    '- `REVIEW_LAYOUT` flags missing `VitPageLayout`, custom `Scaffold` usage, or missing `VitPageContent` when the page is not an accepted `VitPageLayout` custom-scroll composition using shared sizing tokens.',
  );
  lines.push(
    '- `NEEDS_IDENTITY_REVIEW` flags primary action emoji icons, bottom-nav module accent hooks, or local module gradients. These should use `AppModuleAccents` and shared module components.',
  );
  lines.push('');

  return `${lines.join('\n')}\n`;
}

function printSummary(report) {
  console.log('Migrated Home Standard Audit complete');
  console.log(`  Migrated rows: ${report.scope.migratedRows}`);
  console.log(`  Unique presentation files: ${report.scope.uniquePresentationFiles}`);
  console.log(`  Unmapped rows: ${report.scope.unmappedRows}`);
  console.log('  Risk summary:');
  for (const row of report.riskSummary) {
    console.log(`    ${row.riskGrade}: ${row.screens}`);
  }
  console.log(`  Markdown: ${relativePath(OUTPUT_FILES.markdown)}`);
  console.log(`  CSV: ${relativePath(OUTPUT_FILES.csv)}`);
  console.log(`  JSON: ${relativePath(OUTPUT_FILES.json)}`);
}

function csvEscape(value) {
  const text = String(value ?? '');
  if (/[",\n\r]/.test(text)) return `"${text.replaceAll('"', '""')}"`;
  return text;
}

function mdEscape(value) {
  return String(value ?? '').replaceAll('|', '\\|');
}

function relativePath(file) {
  return path.relative(ROOT, file).split(path.sep).join('/');
}

async function primeFileCache(files) {
  await Promise.all(
    files.map(async (file) => {
      fileCache.set(file, await fs.readFile(file, 'utf8'));
    }),
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
