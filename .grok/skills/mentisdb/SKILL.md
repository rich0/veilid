---
name: mentisdb
description: Durable semantic memory for veilid — chain veilid, agent grok-build-cursor.
triggers:
  - mentisdb
  - memory
  - remember
  - recall
  - chain
  - thought
---

# MentisDB — veilid

Repo-scoped override. Full MentisDB patterns: call `mentisdb_skill_md` on the server for the upstream skill, or read `~/.grok/skills/mentisdb/SKILL.md` globally.

## Fixed identifiers (do not change)

| Setting | Value |
|---------|-------|
| `chain_key` | `veilid` |
| `agent_id` | `grok-build-cursor` |

Pass `chain_key="veilid"` on **every** mentisdb tool call in this repository.

## Mandatory startup

**First MCP calls in every session** — before repo search or implementation. Required in plan mode too.

1. `mentisdb_bootstrap(chain_key="veilid", agent_id="grok-build-cursor", content="Session start in veilid; task: <brief user goal>")` — `content` is **required**
2. `mentisdb_list_agents(chain_key="veilid")` — reuse `grok-build-cursor`; never auto-create agents
3. `mentisdb_recent_context(chain_key="veilid", agent_id="grok-build-cursor", last_n=20)`
4. `mentisdb_ranked_search(chain_key="veilid", text="<current task>", limit=10)`
5. `mentisdb_append` a `Summary` with `role: Checkpoint` before starting work

If bootstrap fails with `missing field content`, retry with a non-empty `content` string.

## Memory scope

- **This repo:** MentisDB only (`chain_key="veilid"`). All project decisions, lessons, and conventions go here.
- **Global personal prefs:** Grok `~/.grok/memory/MEMORY.md` is fine for cross-project habits — never duplicate repo facts there.
- Do **not** use Grok `memory_search` / `memory_get` for project-specific recall in this repository.

## Write discipline

Search with `mentisdb_ranked_search(chain_key="veilid", ...)` before every `mentisdb_append`. Link `refs` to related thoughts. Write `LessonLearned`, `Decision`, `Constraint`, and `Checkpoint` thoughts eagerly — including after posting plans or finishing research.