# Claude Code — Session Opener Prompts

Two prompts. Use one when starting Claude Code in this repo.

---

## A. Short opener (recommended — paste this every session)

```
Read CLAUDE.md, then PROGRESS.md. Tell me where we left off, what the next planned task is, and confirm before starting work. Do not write code until I approve the task.
```

That's it. `CLAUDE.md` already contains the role, rules, scoring template, and "session protocol." `PROGRESS.md` has the actual state. You don't need to paste a 200-line prompt every time.

---

## B. Long opener (paste only when starting a fresh, important session — e.g. a new architectural decision)

```
You are acting as a Senior Staff Mobile Architect reviewing a real startup MVP before scaling. Project: FITEAT, a Flutter + Supabase social recipe app.

Before responding:
1. Read CLAUDE.md (role, rules, ground truths).
2. Read PRD.md (product scope, priority tiers).
3. Read PROGRESS.md (last session, current task, decisions log).
4. Read docs/ARCHITECTURE_REVIEW.md if I ask anything architectural.

Constraints:
- Flutter + Dart, Cubit (flutter_bloc + equatable), GoRouter, GetIt, Supabase.
- Local Supabase via Docker. Not in production yet.
- Default mode: architectural reasoning, not code generation. Write code only when I explicitly ask.

Behavior:
- Be brutally specific. No generic advice. Reference files, table names, line numbers.
- Distinguish MVP / V1 / V2 for every feature you discuss.
- Challenge bad ideas. Correctness over agreement.
- No emojis.

End every architectural response with:
1. Current architecture score (1–10)
2. MVP readiness score (1–10)
3. Scalability score (1–10)
4. Biggest technical risk (one sentence)
5. Next 3 highest-priority tasks

Now: tell me what's in PROGRESS.md → Current Task and ask me which task to pick up.
```

---

## C. End-of-session ritual (say this when you're done for the day)

```
Update PROGRESS.md:
- Move what we just finished into "Completed" with today's date.
- Update "Current Task" with what's in flight (or set to "Nothing in progress").
- Update "Next planned task" with the top of Backlog (re-order Backlog if needed).
- Append a "Decisions Log" entry for any non-trivial decision we made today.
Then summarize the session in 5 bullet points.
```

---

## How Claude Code remembers context across sessions (read once)

Claude Code does **not** keep memory between sessions on its own. The mechanisms it uses are:

1. **`CLAUDE.md`** — automatically loaded at the start of every session. **This is the only file Claude Code reads without being told to.** That's why role, ground rules, locked decisions, and the "session protocol" live there.
2. **Imports** — `CLAUDE.md` can reference other files (e.g. `PROGRESS.md`). Claude will read them when the protocol in `CLAUDE.md` tells it to. That's why `CLAUDE.md` §0 explicitly instructs Claude to read `PROGRESS.md` next.
3. **`PROGRESS.md`** — you maintain it. Claude updates it at end-of-session when you tell it to (option C above). This is your "where did we leave off" memory.
4. **`/resume` and `--continue`** — Claude Code's flags to reopen a past conversation history. Useful for short-term context (same day), not for week-over-week. **Don't rely on this** — rely on `PROGRESS.md` instead, because conversation history can be lost when you switch machines, clear caches, or hit token limits.
5. **`/clear`** — wipes the in-session context. Use it when you start a brand-new unrelated task, NOT when you want to continue. After `/clear`, paste the short opener (A) to get back into the right mindset; `CLAUDE.md` will still be loaded automatically.

**Bottom line:** `CLAUDE.md` carries the rules. `PROGRESS.md` carries the state. Update `PROGRESS.md` at the end of every session and you'll never wonder where you left off.

---

## Quality-of-life additions

- Add a `.claude/` directory if you want session-specific notes that don't belong in the main docs.
- Consider a `tools/scripts/session_start.sh` that prints `cat PROGRESS.md` so you skim before opening Claude Code.
- Pin `CLAUDE.md` and `PROGRESS.md` in your editor sidebar.
