# MentisDB memory (veilid)

## Memory scope

| Scope | System | Examples |
|-------|--------|----------|
| **This repo** | MentisDB chain `veilid` | Docker image decisions, veilid-server version pins, build/debug lessons |
| **Cross-project personal** | Grok `~/.grok/memory/MEMORY.md` (optional) | Communication style, global workflow habits |

Do **not** duplicate repo-specific facts in Grok workspace memory. Use MentisDB for all project knowledge in this repository.

## Chain and agent

- **Chain:** `veilid` — pass `chain_key="veilid"` on **every** mentisdb MCP call.
- **Agent:** `grok-build-cursor` — reuse this identity; do not create new agent IDs.

## Mandatory session startup

**First MCP calls in every session** — before any repo search, file read, or implementation. Applies in plan mode and agent mode; MentisDB writes are not repo edits.

1. `mentisdb_bootstrap(chain_key="veilid", agent_id="grok-build-cursor", content="Session start in veilid; task: <brief user goal>")` — `content` is **required** by the MCP tool
2. `mentisdb_skill_md` (or read repo `.grok/skills/mentisdb/SKILL.md`)
3. `mentisdb_list_agents(chain_key="veilid")` — confirm `grok-build-cursor` exists
4. `mentisdb_recent_context(chain_key="veilid", agent_id="grok-build-cursor", last_n=20)`
5. `mentisdb_ranked_search(chain_key="veilid", text="<current task>", limit=10)`
6. `mentisdb_append` a `Summary` with `role: Checkpoint` before substantive work

If `mentisdb_bootstrap` fails, retry with a non-empty `content` string before proceeding.

## During work

- **Recall:** `mentisdb_ranked_search` with `chain_key="veilid"`
- **Persist:** `mentisdb_append` with `chain_key="veilid"`, `agent_id="grok-build-cursor"` — search before every write
- **Checkpoints:** write `Summary` / `Decision` / `LessonLearned` before compaction, handoff, or posting a plan

## Do not

- Store **repo-specific** facts in `~/.grok/memory/` or via Grok `memory_search` / `memory_get`
- Duplicate MentisDB thoughts into Grok workspace memory
- Omit `chain_key` on mentisdb calls (server default may be stale)
- Create new mentisdb agent IDs without explicit user authorization
- Skip startup because MCP is still connecting — wait and retry bootstrap first