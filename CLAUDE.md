# LOGOS AGENT — Global Claude Code Config
# Path: C:\Users\Ben\.claude\CLAUDE.md
# Scope: Fires on every Claude Code session across all tranches

---

## 1. Skills Discovery

At the start of any new project or tranche, fetch the skills index:

```
https://wasatchphone-ux.github.io/logos-pages/skills-index.json
```

- Match repos by `use_when[]` fields against the current task description
- Install relevant SKILL.md files to `.claude/skills/` before writing code
- Prioritize repos marked `logos_relevance: HIGH`
- Skip anything with `caveat` that conflicts with the constraints below
- If uncertain which skills apply, ask before installing

---

## 2. Stack Constraints (Non-Negotiable)

These apply to ALL tranches. Never suggest alternatives that violate them.

- **No cloud dependencies** — local-first always
- **SQLite over Postgres** — no external database services
- **Free-tier APIs only** — no paid API calls without explicit approval
- **No cloud storage** — local filesystem or GitHub only
- **Runtime**: Python and/or JavaScript/Node depending on tranche
- **Agent runtime**: Claude Code + Claude Desktop
- **Platform**: Windows (GMKtec M5 Ultra, no discrete GPU)

---

## 3. Active Tranches

| ID | Name | Priority | Status |
|----|------|----------|--------|
| T1 | WCS Gym System | Active | Shopify + ops automation |
| T2 | NQ Futures Trading | **Priority** | SPEC.md unresolved — dashboard vs automation |
| T3 | Date Curator | Planning | Utah County events, Telegram delivery |
| T4 | Muay Thai Curriculum Pipeline | Active | Phase 1 ingestion next |

Key file locations:
- Dashboard: `C:\Users\Ben\.openclaw\workspace\projects\dashboard.html`
- T4 database: `T4/db/t4.db`
- Recapture page: `wasatchphone-ux.github.io/logos-pages/wcs-recapture-v6.html`
- Skills index: `wasatchphone-ux.github.io/logos-pages/skills-index.json`

---

## 4. Think Before Coding

**Never assume. Never hide confusion. Surface tradeoffs.**

- State assumptions explicitly before writing any code
- When ambiguity exists, present interpretations — do not pick silently
- If a simpler approach exists, say so before proceeding
- Stop and ask when confused — do not run with a guess
- For architectural decisions (like T2 dashboard vs automation), present the tradeoff table before writing a single line

---

## 5. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "extensibility" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it
- SQLite is the answer. Do not suggest Postgres, Redis, or any external store unless explicitly asked

**Test**: Would a senior engineer say this is overcomplicated? If yes, simplify.

---

## 6. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Do not "improve" adjacent code, comments, or formatting
- Do not refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — do not delete it
- Every changed line must trace directly to the current request

When your changes create orphans (unused imports, variables, functions):
- Remove what YOUR changes made unused
- Leave pre-existing dead code alone unless asked

---

## 7. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Before writing code, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Transform imperative requests into verifiable goals:
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Add scraping" → "Scrape one URL, verify output matches expected schema"
- "Build ingestion" → "Ingest one video, verify SQLite row exists with correct fields"

For T4 specifically: pilot 5-10 videos before locking schema.

---

## 8. Pilot Before Schema Lock (T4 Rule)

Do not finalize any SQLite schema in T4 until:
- At least 5 real videos have been ingested
- Edge cases in extraction have been observed
- Raw extractions immutable layer is in place

---

## 9. Response Style

- Lead with blockers, risks, and hard constraints before solutions
- No cheerleading before identifying real walls
- AP style — short, direct sentences
- No bullet-point walls for conversational answers
- Step-by-step only during technical walkthroughs
- No em dashes in customer-facing copy
- No phrases: "real talk", "here's the thing", "straightforward"

---

## 10. GitHub

- Account: `wasatchphone-ux`
- PAT (repo scope): `[REDACTED — store locally never commit]`
- Git email: `kboxer@msn.com`
- Git name: `Ben WCS`
- Pages base: `https://wasatchphone-ux.github.io/logos-pages/`

---

## 11. Quick Reference — HIGH Priority Skills

These apply broadly across all tranches. Install when relevant:

| Repo | Use When |
|------|----------|
| `firecrawl/firecrawl` | Any JS-rendered scraping (T3) |
| `googleapis/mcp-toolbox` | Agent needs direct SQLite/DB access |
| `VoltAgent/awesome-agent-skills` | Any new build — check for official skills first |
| `public-apis/public-apis` | Finding free signal or data sources (T2, T3) |
| `ripienaar/free-for-dev` | Finding zero-cost infrastructure |
| `rohitg00/llm-wiki` | Designing memory/knowledge pipeline (T4) |
| `obra/superpowers` | Before writing any SPEC.md |
| `addyosmani/agent-skills` | Any build phase — spec, test, review, ship |
