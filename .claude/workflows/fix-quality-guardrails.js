export const meta = {
  name: 'fix-quality-guardrails',
  description: 'Discover failing flutter_app/test/quality/ guardrail tests, regenerate stale audit artifacts, fix real violations via a Sonnet builder, verify objectively, then have Opus review — retry up to 5 attempts.',
  phases: [
    { title: 'Discover' },
    { title: 'Regenerate' },
    { title: 'Fix' },
    { title: 'Verify' },
    { title: 'Review', model: 'opus' },
  ],
}

// Scope: test/quality/ guardrail backlog only. See
// docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md §2 for the
// domain table this workflow reads dynamically (never hard-code domain
// commands here — the table is the source of truth and it changes).

const DISCOVER_SCHEMA = {
  type: 'object',
  properties: {
    failing: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          testFile: { type: 'string', description: 'filename relative to flutter_app/test/quality/, e.g. card_tile_guardrail_test.dart' },
          testName: { type: 'string' },
        },
        required: ['testFile'],
      },
    },
  },
  required: ['failing'],
}

const CLASSIFY_SCHEMA = {
  type: 'object',
  properties: {
    items: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          testFile: { type: 'string' },
          domain: { type: 'string' },
          hasTool: { type: 'boolean', description: 'true if the table Tool column is a real tool/*.dart path, false if it is "—"' },
          regenerateCommand: { type: 'string', description: 'exact "Regenerate / check command" column text; empty if hasTool=false' },
        },
        required: ['testFile', 'domain', 'hasTool'],
      },
    },
  },
  required: ['items'],
}

const REGEN_RESULT_SCHEMA = {
  type: 'object',
  properties: {
    testFile: { type: 'string' },
    stillFailing: { type: 'boolean' },
    notes: { type: 'string' },
  },
  required: ['testFile', 'stillFailing'],
}

const FIX_RESULT_SCHEMA = {
  type: 'object',
  properties: {
    testFile: { type: 'string' },
    changed: { type: 'array', items: { type: 'string' } },
    summary: { type: 'string' },
  },
  required: ['testFile', 'summary'],
}

const VERIFY_SCHEMA = {
  type: 'object',
  properties: {
    testsPass: { type: 'boolean' },
    analyzeClean: { type: 'boolean' },
    diffStat: { type: 'string' },
    testOutputSummary: { type: 'string' },
  },
  required: ['testsPass', 'analyzeClean', 'diffStat'],
}

const OPUS_VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    approved: { type: 'boolean' },
    notes: { type: 'string' },
    issuesFound: { type: 'array', items: { type: 'string' } },
  },
  required: ['approved', 'notes', 'issuesFound'],
}

function regenPrompt(item, priorNotes) {
  return (
    `From flutter_app/, regenerate the on-disk audit artifact for domain "${item.domain}". ` +
    `Take the table command "${item.regenerateCommand}" and run its WRITE mode: the same command with the ` +
    `--check flag removed, keeping any other flags (e.g. --strict-full, --strict). If you are not sure how the ` +
    `tool distinguishes write vs check mode, read the first ~40 lines of the corresponding tool/*.dart file to ` +
    `confirm before running anything. Do NOT hand-edit the generated .csv/.md artifact yourself — only the tool ` +
    `may write it. After regenerating, run exactly: flutter test test/quality/${item.testFile} --reporter=compact ` +
    `and report testFile, whether it is stillFailing (true/false), and any notes.` +
    (priorNotes ? `\n\nNotes from a previous rejected attempt — avoid repeating these mistakes:\n${priorNotes}` : '')
  )
}

function fixPrompt(item, priorNotes) {
  return (
    `The VitTrade Flutter guardrail test test/quality/${item.testFile} is failing, and regenerating its audit ` +
    `artifact (if it has one) did NOT fix it — this is a real, live violation, not stale data. Investigate the ` +
    `actual source cause: read the test file itself, the matching audit tool under tool/ if one exists, and the ` +
    `production files it flags. Fix the root cause in production code — do not weaken, delete, or special-case ` +
    `the check just to make it pass. If instead the TEST's own expectation is what's stale (e.g. it hardcodes a ` +
    `file/pattern that was legitimately refactored elsewhere on purpose), confirm that via git log/git diff before ` +
    `touching the test, and explain your reasoning in the summary. Re-run ` +
    `flutter test test/quality/${item.testFile} --reporter=compact to confirm it passes before returning.` +
    (priorNotes ? `\n\nNotes from a previous rejected attempt — avoid repeating these mistakes:\n${priorNotes}` : '')
  )
}

phase('Discover')
const discover = await agent(
  'Run "flutter test test/quality/ --reporter=compact" from flutter_app/ (a real command — do not guess or ' +
  'recall a past result). Report every currently-failing test: its file (relative to flutter_app/test/quality/) ' +
  'and test name. If there are zero failures, return an empty "failing" array.',
  { schema: DISCOVER_SCHEMA, phase: 'Discover', label: 'discover' }
)

if (!discover.failing || discover.failing.length === 0) {
  log('test/quality/ is fully green — nothing to fix.')
  return { status: 'CLEAN', attempt: 0, history: [] }
}
log(`${discover.failing.length} failing test(s) found in test/quality/ — starting fix loop`)

let priorNotes = ''
let attempt = 1
let passed = false
const history = []

while (attempt <= 5 && !passed) {
  log(`Attempt ${attempt}/5`)

  phase('Regenerate')
  const classify = await agent(
    'Read docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md §2 (the audit-domain table). For each of ' +
    `these currently-failing test/quality/ files: ${JSON.stringify(discover.failing)} — find the matching table ` +
    'row (match by the "Guardrail test" column filename). For each, report: the domain name, whether the "Tool" ' +
    'column is a real tool/*.dart path (hasTool=true) or "—" (hasTool=false), and if hasTool, the exact ' +
    '"Regenerate / check command" column text. Do not invent or guess a command — copy it verbatim from the table.',
    { schema: CLASSIFY_SCHEMA, phase: 'Regenerate', label: 'classify', agentType: 'flutter-domain-auditor' }
  )

  const withTool = classify.items.filter((i) => i.hasTool)
  const withoutTool = classify.items.filter((i) => !i.hasTool)

  const isCardTileFamily = (i) => /card.?tile/i.test(i.domain) || /card_tile/i.test(i.regenerateCommand || '')
  const isManifestTool = (i) => /manifest/i.test(i.regenerateCommand || '')
  const cardTileItems = withTool.filter(isCardTileFamily).sort((a, b) => (isManifestTool(a) ? 1 : 0) - (isManifestTool(b) ? 1 : 0))
  const otherToolItems = withTool.filter((i) => !isCardTileFamily(i))

  const cardTileResults = []
  for (const item of cardTileItems) {
    cardTileResults.push(await agent(regenPrompt(item, priorNotes), { schema: REGEN_RESULT_SCHEMA, phase: 'Regenerate', label: `regen:${item.domain}` }))
  }
  const otherResults = await parallel(otherToolItems.map((item) => () => agent(regenPrompt(item, priorNotes), { schema: REGEN_RESULT_SCHEMA, phase: 'Regenerate', label: `regen:${item.domain}` })))
  const regenResults = [...cardTileResults, ...otherResults].filter(Boolean)

  const stillFailing = [
    ...withoutTool.map((i) => ({ testFile: i.testFile, domain: i.domain })),
    ...regenResults.filter((r) => r.stillFailing).map((r) => ({ testFile: r.testFile })),
  ]

  phase('Fix')
  let fixResults = []
  if (stillFailing.length > 0) {
    log(`${stillFailing.length} test(s) still failing after artifact regeneration — need real investigation/fix`)
    fixResults = (
      await parallel(
        stillFailing.map((item) => () =>
          agent(fixPrompt(item, priorNotes), {
            agentType: 'flutter-batch-builder',
            schema: FIX_RESULT_SCHEMA,
            phase: 'Fix',
            label: `fix:${item.testFile}`,
          })
        )
      )
    ).filter(Boolean)
  } else {
    log('All failing tests were pure stale-artifact — resolved by regeneration alone.')
  }

  phase('Verify')
  const verify = await agent(
    'From flutter_app/, run exactly: 1) flutter test test/quality/ --reporter=compact  2) flutter analyze  ' +
    '3) git diff --stat -- test/quality/ lib/ docs/02_FLUTTER_MIGRATION/audits/ — and report raw results, do not ' +
    'summarize away failures. Report testsPass (bool: every test/quality/ test passing), analyzeClean (bool), ' +
    'diffStat (the raw diff --stat text), and a short testOutputSummary.',
    { schema: VERIFY_SCHEMA, phase: 'Verify', label: 'verify' }
  )

  phase('Review')
  const verdict = await agent(
    `You are reviewing a fix for VitTrade Flutter's test/quality/ guardrail backlog — attempt ${attempt} of 5. ` +
    `Tests that were failing at the start of this attempt: ${JSON.stringify(discover.failing)}. ` +
    `Tests that needed a REAL code fix (not just artifact regeneration) this attempt: ${JSON.stringify(stillFailing)}, ` +
    `with fix summaries: ${JSON.stringify(fixResults)}. Objective verification output: ${JSON.stringify(verify)}. ` +
    'Run "git diff HEAD" yourself, scoped to lib/ and test/, to see the actual changes before judging — do not ' +
    'trust the summaries alone. Answer three questions: (1) For every real code fix, is it an actual root-cause ' +
    'fix, or does it dodge/weaken the check (e.g. editing a regex, deleting a test, hardcoding an exception)? ' +
    '(2) For every regenerated artifact, was it produced by actually running the tool, not hand-edited? ' +
    '(3) Are there any regressions elsewhere in the repo (check the flutter analyze output, and run a broader ' +
    'test slice yourself if the diff touches widely-shared widgets)? Approve only if (1) is "real fix" for every ' +
    'code-fix item, (2) is "yes" for every artifact, (3) shows no regressions, AND verify.testsPass === true.',
    { model: 'opus', schema: OPUS_VERDICT_SCHEMA, phase: 'Review', label: 'opus-review' }
  )

  const testsPass = !!verify.testsPass
  passed = testsPass && !!verdict.approved
  history.push({ attempt, testsPass, stillFailing, regenResults, fixResults, verdict })
  log(`Attempt ${attempt}: testsPass=${testsPass} opusApproved=${verdict.approved} -> ${passed ? 'PASSED' : 'retry'}`)

  if (!passed) {
    priorNotes = `Opus verdict (attempt ${attempt}): approved=${verdict.approved}\nnotes: ${verdict.notes}\nissuesFound: ${JSON.stringify(verdict.issuesFound)}`
  }
  attempt++
}

return {
  status: passed ? 'PASSED' : 'FAILED_MAX_ATTEMPTS',
  attempt: attempt - 1,
  history,
}
