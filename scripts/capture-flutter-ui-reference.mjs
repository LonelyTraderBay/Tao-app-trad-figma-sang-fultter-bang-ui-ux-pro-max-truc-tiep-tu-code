import { chromium } from '@playwright/test';
import { spawn } from 'node:child_process';
import { createServer } from 'node:net';
import { existsSync } from 'node:fs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = path.resolve(__dirname, '..');
const OUTPUT_ROOT = path.join(ROOT, 'output', 'flutter-ui-reference');
const SCREENSHOT_ROOT = path.join(OUTPUT_ROOT, 'screenshots');
const LOG_ROOT = path.join(OUTPUT_ROOT, 'logs');

const ROUTE_FILES = {
  routes: path.join(ROOT, 'src', 'app', 'routes.ts'),
  routeConfig: path.join(ROOT, 'src', 'app', 'routeConfig.ts'),
  staking: path.join(ROOT, 'src', 'app', 'routes', 'stakingRoutes.lazy.ts'),
};

const VIEWPORT = { width: 440, height: 956 };
const SMOKE_ROUTES = new Set([
  '/auth/login',
  '/home',
  '/markets/predictions/event/pred-1',
  '/trade/btcusdt',
  '/wallet/asset/btc',
  '/p2p/order/p2p001',
  '/arena/challenge/ch003',
  '/earn/savings/product/sample',
]);

const PARAM_VALUES = {
  pairId: 'btcusdt',
  eventId: 'pred-1',
  orderId: 'p2p001',
  providerId: 'provider001',
  copyId: 'copy001',
  traderId: 'trader001',
  asset: 'USDT',
  assetId: 'btc',
  txId: 'tx001',
  configId: 'config001',
  adId: 'ad001',
  merchantId: 'mc001',
  id: 'sample',
  productId: 'sample',
  positionId: 'pos001',
  subId: 'sub001',
  contractId: 'contract001',
  challengeId: 'ch003',
  modeId: 'mode001',
  creatorId: 'cr001',
  userId: 'user001',
  entryId: 'entry001',
  caseId: 'case001',
  topicId: 'crypto',
  friendId: 'friend001',
  proposalId: 'prop001',
};

function parseArgs(argv) {
  const args = {
    smoke: false,
    dryRun: false,
    baseUrl: '',
    limit: 0,
    route: '',
    keepExisting: false,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--smoke') args.smoke = true;
    else if (arg === '--dry-run') args.dryRun = true;
    else if (arg === '--keep-existing') args.keepExisting = true;
    else if (arg === '--base-url') args.baseUrl = argv[++i] ?? '';
    else if (arg.startsWith('--base-url=')) args.baseUrl = arg.slice('--base-url='.length);
    else if (arg === '--limit') args.limit = Number(argv[++i] ?? 0);
    else if (arg.startsWith('--limit=')) args.limit = Number(arg.slice('--limit='.length));
    else if (arg === '--route') args.route = argv[++i] ?? '';
    else if (arg.startsWith('--route=')) args.route = arg.slice('--route='.length);
  }

  return args;
}

function escapeCsv(value) {
  const text = String(value ?? '');
  if (!/[",\n\r]/.test(text)) return text;
  return `"${text.replace(/"/g, '""')}"`;
}

function toSlug(value) {
  return String(value || 'screen')
    .replace(/([A-Z0-9]+)([A-Z][a-z])/g, '$1-$2')
    .replace(/([a-z0-9])([A-Z])/g, '$1-$2')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .toLowerCase();
}

function cleanComponentName(component) {
  if (!component) return '';
  return component
    .replace(/^o\./, '')
    .replace(/^React\.createElement\(/, '')
    .replace(/[,)].*$/, '')
    .trim();
}

function routePatternToResolved(routePattern) {
  return routePattern.replace(/:([A-Za-z0-9_]+)/g, (_, key) => PARAM_VALUES[key] ?? 'sample');
}

function pathJoinRoute(parent, child, isIndex = false) {
  const normalizedParent = parent.replace(/^\/+|\/+$/g, '');
  if (isIndex) return normalizedParent ? `/${normalizedParent}` : '/';

  const normalizedChild = child.replace(/^\/+|\/+$/g, '');
  if (!normalizedParent) return `/${normalizedChild}`;
  if (!normalizedChild) return `/${normalizedParent}`;
  return `/${normalizedParent}/${normalizedChild}`;
}

function inferModule(routePattern) {
  const parts = routePattern.replace(/^\/+/, '').split('/').filter(Boolean);
  const first = parts[0] ?? 'root';
  const second = parts[1] ?? '';

  if (first === 'markets' && second === 'predictions') return 'predictions';
  if (first === 'pair' || first === 'markets') return 'markets';
  if (first === 'auth') return 'auth';
  if (first === 'onboarding') return 'onboarding';
  if (first === 'trade') return 'trade';
  if (first === 'wallet') return 'wallet';
  if (first === 'p2p') return 'p2p';
  if (first === 'arena') return 'arena';
  if (first === 'earn') return 'earn';
  if (first === 'launchpad') return 'launchpad';
  if (first === 'admin') return 'admin';
  if (first === 'dev') return 'dev';
  if (first === 'demo') return 'demo';
  if (first === 'profile') return 'profile';
  if (first === 'dca') return 'dca';
  if (first === 'referral') return 'referral';
  if (first === 'support') return 'support';
  if (['search', 'topics', 'topic'].includes(first)) return 'discovery';
  if (['unified-portfolio', 'cross-module-analytics', 'smart-alerts', 'tax-reports'].includes(first)) return 'cross-module';
  return first || 'root';
}

function screenNameFor(component, routePattern) {
  const clean = cleanComponentName(component);
  if (clean) return clean;
  const route = routePattern.replace(/^\/+/, '').replace(/\/:[^/]+/g, '');
  return route
    .split('/')
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ') || 'Root';
}

function getLineNumber(text, index) {
  return text.slice(0, index).split(/\r?\n/).length;
}

function scanWithSyntax(text, start, visitor) {
  let quote = '';
  let lineComment = false;
  let blockComment = false;
  for (let i = start; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];

    if (lineComment) {
      if (char === '\n') lineComment = false;
      continue;
    }
    if (blockComment) {
      if (char === '*' && next === '/') {
        blockComment = false;
        i += 1;
      }
      continue;
    }
    if (quote) {
      if (char === '\\') {
        i += 1;
        continue;
      }
      if (char === quote) quote = '';
      continue;
    }
    if (char === '/' && next === '/') {
      lineComment = true;
      i += 1;
      continue;
    }
    if (char === '/' && next === '*') {
      blockComment = true;
      i += 1;
      continue;
    }
    if (char === '"' || char === "'" || char === '`') {
      quote = char;
      continue;
    }

    const result = visitor(char, i);
    if (result !== undefined) return result;
  }
  return undefined;
}

function findMatching(text, openIndex, openChar, closeChar) {
  let depth = 0;
  return scanWithSyntax(text, openIndex, (char, i) => {
    if (char === openChar) depth += 1;
    else if (char === closeChar) {
      depth -= 1;
      if (depth === 0) return i;
    }
    return undefined;
  });
}

function extractArrayAfterMarker(text, marker) {
  const markerIndex = text.indexOf(marker);
  if (markerIndex === -1) throw new Error(`Could not find marker: ${marker}`);
  const arrayStart = scanWithSyntax(text, markerIndex + marker.length, (char, i) => (
    char === '[' ? i : undefined
  ));
  if (arrayStart === undefined) throw new Error(`Could not find array after marker: ${marker}`);
  const arrayEnd = findMatching(text, arrayStart, '[', ']');
  if (arrayEnd === undefined) throw new Error(`Could not match array after marker: ${marker}`);
  return {
    content: text.slice(arrayStart + 1, arrayEnd),
    offset: arrayStart + 1,
  };
}

function extractReturnArrayAfterMarker(text, marker) {
  const markerIndex = text.indexOf(marker);
  if (markerIndex === -1) throw new Error(`Could not find marker: ${marker}`);
  const returnIndex = text.indexOf('return', markerIndex + marker.length);
  if (returnIndex === -1) throw new Error(`Could not find return after marker: ${marker}`);
  const arrayStart = scanWithSyntax(text, returnIndex, (char, i) => (
    char === '[' ? i : undefined
  ));
  if (arrayStart === undefined) throw new Error(`Could not find return array after marker: ${marker}`);
  const arrayEnd = findMatching(text, arrayStart, '[', ']');
  if (arrayEnd === undefined) throw new Error(`Could not match return array after marker: ${marker}`);
  return {
    content: text.slice(arrayStart + 1, arrayEnd),
    offset: arrayStart + 1,
  };
}

function topLevelObjects(arrayContent, offset = 0) {
  const objects = [];
  let depth = 0;
  let start = -1;
  scanWithSyntax(arrayContent, 0, (char, i) => {
    if (char === '{') {
      if (depth === 0) start = i;
      depth += 1;
    } else if (char === '}') {
      depth -= 1;
      if (depth === 0 && start !== -1) {
        objects.push({
          text: arrayContent.slice(start, i + 1),
          absoluteIndex: offset + start,
        });
        start = -1;
      }
    }
    return undefined;
  });
  return objects;
}

function firstRegex(text, regex) {
  const match = text.match(regex);
  return match ? match[1] : '';
}

function findTopLevelChildrenArray(objectText) {
  let braceDepth = 0;
  let bracketDepth = 0;

  return scanWithSyntax(objectText, 0, (char, i) => {
    if (
      braceDepth === 1 &&
      bracketDepth === 0 &&
      objectText.startsWith('children', i) &&
      /^children\s*:/.test(objectText.slice(i, i + 24))
    ) {
      const arrayStart = scanWithSyntax(objectText, i, (innerChar, innerIndex) => (
        innerChar === '[' ? innerIndex : undefined
      ));
      if (arrayStart === undefined) return null;
      const arrayEnd = findMatching(objectText, arrayStart, '[', ']');
      if (arrayEnd === undefined) return null;
      return {
        content: objectText.slice(arrayStart + 1, arrayEnd),
        offset: arrayStart + 1,
        fieldIndex: i,
      };
    }

    if (char === '{') braceDepth += 1;
    else if (char === '}') braceDepth -= 1;
    else if (char === '[') bracketDepth += 1;
    else if (char === ']') bracketDepth -= 1;

    return undefined;
  }) ?? null;
}

function parseRouteArray({ content, parentPath = '', source, fileText, offset = 0 }) {
  const routes = [];
  const objects = topLevelObjects(content, offset);

  for (const object of objects) {
    const objectText = object.text;
    const children = findTopLevelChildrenArray(objectText);
    const ownFields = children ? objectText.slice(0, children.fieldIndex) : objectText;
    const pathValue = firstRegex(ownFields, /path\s*:\s*'([^']+)'/);
    const isIndex = /\bindex\s*:\s*true\b/.test(ownFields);
    const component = cleanComponentName(firstRegex(ownFields, /Component\s*:\s*([A-Za-z0-9_.$]+)/));
    const routePattern = pathValue || isIndex
      ? pathJoinRoute(parentPath, pathValue, isIndex)
      : parentPath;

    if ((pathValue || isIndex) && component && !children) {
      routes.push({
        routePattern,
        component,
        source,
        line: getLineNumber(fileText, object.absoluteIndex),
      });
    }

    if ((pathValue || isIndex) && component && children && component !== 'AuthLayout') {
      routes.push({
        routePattern,
        component,
        source,
        line: getLineNumber(fileText, object.absoluteIndex),
      });
    }

    if (children) {
      routes.push(...parseRouteArray({
        content: children.content,
        parentPath: routePattern,
        source,
        fileText,
        offset: object.absoluteIndex + children.offset,
      }));
    }
  }

  return routes;
}

async function discoverRoutes() {
  const routeConfig = await fs.readFile(ROUTE_FILES.routeConfig, 'utf8');
  const staking = await fs.readFile(ROUTE_FILES.staking, 'utf8');
  const routesFile = await fs.readFile(ROUTE_FILES.routes, 'utf8');

  const discovered = [];

  const authArray = extractArrayAfterMarker(routeConfig, 'export const authRoutes: RouteObject[] =');
  discovered.push(...parseRouteArray({
    content: authArray.content,
    parentPath: 'auth',
    source: 'src/app/routeConfig.ts#authRoutes',
    fileText: routeConfig,
    offset: authArray.offset,
  }));

  const publicArray = extractReturnArrayAfterMarker(routeConfig, 'export function createPublicRoutes');
  discovered.push(...parseRouteArray({
    content: publicArray.content,
    parentPath: '',
    source: 'src/app/routeConfig.ts#createPublicRoutes',
    fileText: routeConfig,
    offset: publicArray.offset,
  }));

  const protectedArray = extractReturnArrayAfterMarker(routeConfig, 'export function createProtectedRoutes');
  discovered.push(...parseRouteArray({
    content: protectedArray.content,
    parentPath: '',
    source: 'src/app/routeConfig.ts#createProtectedRoutes',
    fileText: routeConfig,
    offset: protectedArray.offset,
  }));

  const stakingArray = extractReturnArrayAfterMarker(staking, 'export function createStakingRoutes');
  discovered.push(...parseRouteArray({
    content: stakingArray.content,
    parentPath: '',
    source: 'src/app/routes/stakingRoutes.lazy.ts#createStakingRoutes',
    fileText: staking,
    offset: stakingArray.offset,
  }));

  const rootExtras = [
    { routePattern: '/onboarding', component: 'OnboardingFlow', source: 'src/app/routes.ts', line: lineFor(routesFile, 'path: \'onboarding\'') },
    { routePattern: '/dev/showcase', component: 'MissingScreensShowcasePage', source: 'src/app/routes.ts', line: lineFor(routesFile, 'dev/showcase') },
    { routePattern: '/dev/design-system', component: 'DesignSystemPage', source: 'src/app/routes.ts', line: lineFor(routesFile, 'dev/design-system') },
    { routePattern: '/dev/dca-overview', component: 'DCAOverviewDemo', source: 'src/app/routes.ts', line: lineFor(routesFile, 'dev/dca-overview') },
    { routePattern: '/demo/copy-card', component: 'CopyTradingCardDemo', source: 'src/app/routes.ts', line: lineFor(routesFile, 'demo/copy-card') },
  ];
  discovered.push(...rootExtras);

  const seen = new Set();
  return discovered
    .filter((route) => route.routePattern && route.routePattern !== '/')
    .filter((route) => {
      const key = route.routePattern;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    })
    .map((route, index) => {
      const resolvedUrl = routePatternToResolved(route.routePattern);
      const moduleName = inferModule(route.routePattern);
      const screenName = screenNameFor(route.component, route.routePattern);
      const routeSlug = toSlug(resolvedUrl.replace(/^\/+/, '').replace(/\//g, '-'));
      const screenSlug = toSlug(screenName);
      const order = index + 1;
      const fileBase = `${String(order).padStart(3, '0')}_${moduleName}_${screenSlug}__${routeSlug}`;
      return {
        order,
        module: moduleName,
        routePattern: route.routePattern,
        resolvedUrl,
        screenName,
        component: route.component,
        source: `${route.source}:${route.line}`,
        viewportImage: path.posix.join('screenshots', moduleName, `${fileBase}__viewport.png`),
        fullpageImage: path.posix.join('screenshots', moduleName, `${fileBase}__fullpage.png`),
        status: 'pending',
        error: '',
      };
    });
}

function lineFor(text, needle) {
  const index = text.indexOf(needle);
  return index >= 0 ? getLineNumber(text, index) : 1;
}

async function getAvailablePort(preferred = 4174) {
  return new Promise((resolve, reject) => {
    const server = createServer();
    server.unref();
    server.on('error', reject);
    server.listen(preferred, '127.0.0.1', () => {
      const address = server.address();
      server.close(() => resolve(address.port));
    });
  }).catch(() => new Promise((resolve, reject) => {
    const server = createServer();
    server.unref();
    server.on('error', reject);
    server.listen(0, '127.0.0.1', () => {
      const address = server.address();
      server.close(() => resolve(address.port));
    });
  }));
}

async function waitForServer(baseUrl, timeoutMs = 45000) {
  const started = Date.now();
  let lastError = null;
  while (Date.now() - started < timeoutMs) {
    try {
      const res = await fetch(baseUrl, { method: 'GET' });
      if (res.ok || res.status < 500) return;
    } catch (error) {
      lastError = error;
    }
    await new Promise((resolve) => setTimeout(resolve, 500));
  }
  throw new Error(`Timed out waiting for Vite at ${baseUrl}: ${lastError?.message ?? 'no response'}`);
}

async function startVite() {
  const port = await getAvailablePort(4174);
  const viteBin = path.join(ROOT, 'node_modules', 'vite', 'bin', 'vite.js');
  const child = spawn(process.execPath, [viteBin, '--host', '127.0.0.1', '--port', String(port)], {
    cwd: ROOT,
    env: { ...process.env, BROWSER: 'none' },
    stdio: ['ignore', 'pipe', 'pipe'],
  });

  child.stdout.on('data', (chunk) => process.stdout.write(`[vite] ${chunk}`));
  child.stderr.on('data', (chunk) => process.stderr.write(`[vite] ${chunk}`));

  const baseUrl = `http://127.0.0.1:${port}`;
  await waitForServer(baseUrl);

  return {
    baseUrl,
    stop: async () => {
      if (child.exitCode !== null) return;
      child.kill('SIGTERM');
      await new Promise((resolve) => {
        const timeout = setTimeout(resolve, 2000);
        child.once('exit', () => {
          clearTimeout(timeout);
          resolve();
        });
      });
    },
  };
}

async function prepareOutput(keepExisting) {
  const normalizedOutput = path.resolve(OUTPUT_ROOT);
  const expectedPrefix = `${path.resolve(ROOT, 'output')}${path.sep}`;
  if (!normalizedOutput.startsWith(expectedPrefix)) {
    throw new Error(`Refusing to clean unexpected output path: ${normalizedOutput}`);
  }

  if (!keepExisting) {
    await fs.rm(normalizedOutput, { recursive: true, force: true });
  }
  await fs.mkdir(SCREENSHOT_ROOT, { recursive: true });
  await fs.mkdir(LOG_ROOT, { recursive: true });
}

async function addStableCaptureStyles(page) {
  await page.addStyleTag({
    content: `
      *, *::before, *::after {
        animation-duration: 0s !important;
        animation-delay: 0s !important;
        transition-duration: 0s !important;
        transition-delay: 0s !important;
        scroll-behavior: auto !important;
        caret-color: transparent !important;
      }
      body {
        overflow: hidden !important;
      }
    `,
  });
}

async function seedCaptureBrowserState(context) {
  await context.addInitScript(() => {
    try {
      window.localStorage.setItem(
        'app_coachmark_state',
        JSON.stringify({
          seen: [],
          dismissed: [],
          disabled: true,
          lastShown: Date.now(),
        }),
      );
    } catch {
      // Ignore storage failures so capture can continue on restricted origins.
    }
  });
}

async function expandForFullPage(page) {
  return page.evaluate(() => {
    const changed = [];
    const remember = (node, styles) => {
      if (!node) return;
      const original = {};
      for (const key of Object.keys(styles)) {
        original[key] = node.style[key];
        node.style[key] = styles[key];
      }
      changed.push([node, original]);
    };

    const scroll = document.querySelector('[data-pull-scroll]');
    if (!scroll) {
      const height = Math.max(
        document.body.scrollHeight,
        document.documentElement.scrollHeight,
        window.innerHeight,
      );
      return { expanded: false, height };
    }

    const app = document.querySelector('#app-layout-root');
    const frame = app?.parentElement;
    const outer = frame?.parentElement;
    const scrollHeight = Math.max(scroll.scrollHeight, scroll.clientHeight);
    const statusHeight = 59;
    const bottomChrome = 92;
    const fullHeight = Math.max(956, scrollHeight + statusHeight + bottomChrome);

    remember(document.documentElement, { height: `${fullHeight}px`, overflow: 'visible' });
    remember(document.body, { height: `${fullHeight}px`, minHeight: `${fullHeight}px`, overflow: 'visible' });
    remember(outer, { minHeight: `${fullHeight}px`, alignItems: 'flex-start', justifyContent: 'center', overflow: 'visible' });
    remember(frame, { height: `${fullHeight}px`, maxHeight: 'none', overflow: 'visible' });
    remember(app, { height: `${fullHeight}px`, minHeight: `${fullHeight}px`, overflow: 'visible' });
    remember(scroll, {
      height: `${scrollHeight}px`,
      minHeight: `${scrollHeight}px`,
      overflow: 'visible',
      flex: 'none',
    });

    window.__flutterCaptureRestore = () => {
      for (const [node, original] of changed.reverse()) {
        for (const [key, value] of Object.entries(original)) {
          node.style[key] = value;
        }
      }
      delete window.__flutterCaptureRestore;
    };

    return { expanded: true, height: fullHeight };
  });
}

async function restoreAfterFullPage(page) {
  await page.evaluate(() => {
    if (typeof window.__flutterCaptureRestore === 'function') {
      window.__flutterCaptureRestore();
    }
  });
}

async function safeScreenshot(page, entry, baseUrl) {
  const url = new URL(entry.resolvedUrl, baseUrl).toString();
  const viewportPath = path.join(OUTPUT_ROOT, entry.viewportImage);
  const fullpagePath = path.join(OUTPUT_ROOT, entry.fullpageImage);
  await fs.mkdir(path.dirname(viewportPath), { recursive: true });

  const errors = [];
  const consoleErrors = [];
  page.on('pageerror', (error) => errors.push(error.message));
  page.on('console', (message) => {
    if (message.type() === 'error') consoleErrors.push(message.text());
  });

  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => {});
  await addStableCaptureStyles(page);
  await page.waitForTimeout(900);

  const bodyTextLength = await page.evaluate(() => document.body.innerText.trim().length).catch(() => 0);

  await page.screenshot({
    path: viewportPath,
    fullPage: false,
    animations: 'disabled',
    caret: 'hide',
  });

  await expandForFullPage(page);
  await page.waitForTimeout(100);
  await page.screenshot({
    path: fullpagePath,
    fullPage: true,
    animations: 'disabled',
    caret: 'hide',
  });
  await restoreAfterFullPage(page);

  const [viewportStat, fullpageStat] = await Promise.all([
    fs.stat(viewportPath),
    fs.stat(fullpagePath),
  ]);

  const warnings = [];
  if (bodyTextLength < 5) warnings.push('body_text_short');
  if (viewportStat.size < 10_000) warnings.push('viewport_file_small');
  if (fullpageStat.size < 10_000) warnings.push('fullpage_file_small');

  return {
    status: errors.length ? 'captured_with_page_errors' : 'captured',
    error: errors.join(' | '),
    warnings,
    consoleErrors: consoleErrors.slice(0, 5),
    viewportBytes: viewportStat.size,
    fullpageBytes: fullpageStat.size,
  };
}

async function writeManifest(entries, report) {
  await fs.mkdir(OUTPUT_ROOT, { recursive: true });
  await fs.writeFile(
    path.join(OUTPUT_ROOT, 'manifest.json'),
    `${JSON.stringify(entries, null, 2)}\n`,
    'utf8',
  );

  const columns = [
    'order',
    'module',
    'routePattern',
    'resolvedUrl',
    'screenName',
    'component',
    'source',
    'viewportImage',
    'fullpageImage',
    'status',
    'error',
  ];
  const rows = [
    columns.join(','),
    ...entries.map((entry) => columns.map((column) => escapeCsv(entry[column])).join(',')),
  ];
  await fs.writeFile(path.join(OUTPUT_ROOT, 'manifest.csv'), `${rows.join('\n')}\n`, 'utf8');

  await fs.writeFile(
    path.join(LOG_ROOT, 'capture-report.json'),
    `${JSON.stringify(report, null, 2)}\n`,
    'utf8',
  );

  await fs.writeFile(path.join(OUTPUT_ROOT, 'gallery.html'), buildGallery(entries, report), 'utf8');
}

function buildGallery(entries, report) {
  const groups = new Map();
  for (const entry of entries) {
    if (!groups.has(entry.module)) groups.set(entry.module, []);
    groups.get(entry.module).push(entry);
  }

  const moduleLinks = [...groups.keys()]
    .map((moduleName) => `<a href="#${moduleName}">${moduleName}</a>`)
    .join('');

  const sections = [...groups.entries()].map(([moduleName, items]) => {
    const cards = items.map((entry) => `
      <article class="card ${entry.status === 'captured' ? '' : 'warn'}">
        <header>
          <strong>${entry.order}. ${escapeHtml(entry.screenName)}</strong>
          <code>${escapeHtml(entry.resolvedUrl)}</code>
          <small>${escapeHtml(entry.status)}${entry.error ? ` - ${escapeHtml(entry.error)}` : ''}</small>
        </header>
        <div class="shots">
          <figure>
            <figcaption>Viewport</figcaption>
            ${entry.status === 'failed' ? '<div class="missing">failed</div>' : `<img src="${entry.viewportImage.replace(/\\/g, '/')}" loading="lazy" />`}
          </figure>
          <figure>
            <figcaption>Full page</figcaption>
            ${entry.status === 'failed' ? '<div class="missing">failed</div>' : `<img src="${entry.fullpageImage.replace(/\\/g, '/')}" loading="lazy" />`}
          </figure>
        </div>
      </article>
    `).join('\n');

    return `
      <section id="${moduleName}">
        <h2>${moduleName} <span>${items.length}</span></h2>
        <div class="grid">${cards}</div>
      </section>
    `;
  }).join('\n');

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>VitTrade Flutter UI Reference Gallery</title>
  <style>
    :root { color-scheme: dark; font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    body { margin: 0; background: #0b0f18; color: #edf2ff; }
    .top { position: sticky; top: 0; z-index: 10; padding: 20px 24px; background: rgba(11,15,24,.94); border-bottom: 1px solid rgba(255,255,255,.08); backdrop-filter: blur(16px); }
    h1 { margin: 0 0 8px; font-size: 22px; }
    p { margin: 0; color: #9aa6bd; }
    nav { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 16px; }
    nav a { color: #d8e2f8; text-decoration: none; padding: 6px 10px; border-radius: 8px; background: rgba(255,255,255,.07); font-size: 12px; }
    main { padding: 24px; }
    section { margin-bottom: 40px; }
    h2 { display: flex; align-items: baseline; gap: 10px; text-transform: capitalize; }
    h2 span { color: #9aa6bd; font-size: 13px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 18px; }
    .card { border: 1px solid rgba(255,255,255,.09); border-radius: 8px; background: #111827; overflow: hidden; }
    .card.warn { border-color: rgba(245,158,11,.45); }
    .card header { display: grid; gap: 4px; padding: 12px 14px; border-bottom: 1px solid rgba(255,255,255,.08); }
    code, small { color: #9aa6bd; font-size: 12px; overflow-wrap: anywhere; }
    .shots { display: grid; grid-template-columns: 1fr 1fr; gap: 1px; background: rgba(255,255,255,.08); }
    figure { margin: 0; background: #050814; }
    figcaption { padding: 8px 10px; color: #9aa6bd; font-size: 12px; background: #0b1220; }
    img { display: block; width: 100%; height: auto; background: #050814; }
    .missing { min-height: 240px; display: grid; place-items: center; color: #f87171; }
  </style>
</head>
<body>
  <div class="top">
    <h1>VitTrade Flutter UI Reference Gallery</h1>
    <p>${report.summary.captured} captured, ${report.summary.failed} failed, ${report.summary.total} total. Generated ${escapeHtml(report.generatedAt)}.</p>
    <nav>${moduleLinks}</nav>
  </div>
  <main>${sections}</main>
</body>
</html>
`;
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

async function ensureChromiumAvailable() {
  const localBrowserDir = path.join(ROOT, 'node_modules', 'playwright-core');
  if (!existsSync(localBrowserDir)) return;
  try {
    const browser = await chromium.launch({ headless: true });
    await browser.close();
  } catch (error) {
    throw new Error(
      `Playwright Chromium is not installed or cannot launch. Run "npx playwright install chromium" and retry. Details: ${error.message}`,
    );
  }
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  await ensureChromiumAvailable();
  await prepareOutput(args.keepExisting);

  let entries = await discoverRoutes();
  if (args.route) {
    const normalized = args.route.startsWith('/') ? args.route : `/${args.route}`;
    entries = entries.filter((entry) => entry.routePattern === normalized || entry.resolvedUrl === normalized);
  }
  if (args.smoke) entries = entries.filter((entry) => SMOKE_ROUTES.has(entry.resolvedUrl));
  if (args.limit > 0) entries = entries.slice(0, args.limit);

  if (entries.length === 0) throw new Error('No routes matched the requested capture filters.');

  if (args.dryRun) {
    const report = {
      generatedAt: new Date().toISOString(),
      baseUrl: '',
      viewport: VIEWPORT,
      mode: args.smoke ? 'smoke-dry-run' : 'full-dry-run',
      summary: { total: entries.length, captured: 0, failed: 0, warnings: 0 },
      results: [],
    };
    await writeManifest(entries, report);
    for (const entry of entries) {
      process.stdout.write(`${entry.order}\t${entry.module}\t${entry.resolvedUrl}\t${entry.screenName}\n`);
    }
    process.stdout.write(`\nDiscovered ${entries.length} routes.\n`);
    process.stdout.write(`Output: ${path.relative(ROOT, OUTPUT_ROOT)}\n`);
    return;
  }

  const server = args.baseUrl
    ? { baseUrl: args.baseUrl.replace(/\/+$/, ''), stop: async () => {} }
    : await startVite();

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: VIEWPORT,
    deviceScaleFactor: 1,
    isMobile: true,
    hasTouch: true,
    reducedMotion: 'reduce',
    colorScheme: 'dark',
  });
  await seedCaptureBrowserState(context);

  const startedAt = new Date().toISOString();
  const report = {
    generatedAt: startedAt,
    baseUrl: server.baseUrl,
    viewport: VIEWPORT,
    mode: args.smoke ? 'smoke' : 'full',
    summary: { total: entries.length, captured: 0, failed: 0, warnings: 0 },
    results: [],
  };

  try {
    for (let i = 0; i < entries.length; i += 1) {
      const entry = entries[i];
      const page = await context.newPage();
      process.stdout.write(`[capture] ${i + 1}/${entries.length} ${entry.resolvedUrl}\n`);
      try {
        const result = await safeScreenshot(page, entry, server.baseUrl);
        entry.status = result.status;
        entry.error = result.error;
        entry.warnings = result.warnings;
        entry.consoleErrors = result.consoleErrors;
        report.summary.captured += 1;
        if (result.warnings.length) report.summary.warnings += 1;
        report.results.push({ ...entry, ...result });
      } catch (error) {
        entry.status = 'failed';
        entry.error = error.stack || error.message || String(error);
        report.summary.failed += 1;
        report.results.push({ ...entry });
        process.stderr.write(`[capture:error] ${entry.resolvedUrl}: ${entry.error}\n`);
      } finally {
        await page.close().catch(() => {});
      }
    }
  } finally {
    await browser.close().catch(() => {});
    await server.stop().catch(() => {});
  }

  await writeManifest(entries, report);

  process.stdout.write(`\nCaptured ${report.summary.captured}/${report.summary.total} routes.\n`);
  process.stdout.write(`Output: ${path.relative(ROOT, OUTPUT_ROOT)}\n`);
  if (report.summary.failed > 0) process.exitCode = 1;
}

run().catch((error) => {
  process.stderr.write(`${error.stack || error.message || String(error)}\n`);
  process.exitCode = 1;
});
