# Agent guide (rich0/veilid)

Docker image for [veilid-server](https://github.com/veilid/veilid). Follow these conventions for all changes.

## Repository layout

- `Dockerfile` — main image (ubuntu:resolute, apt packages from packages.veilid.net)
- `veilid-server.conf` — server config copied into the image
- `build-push.sh` — build and push to `ghcr.io/rich0/veilid` (pins `VEILID_VERSION`)
- `nightly/` — separate nightly image build

## Docker conventions

- Pin `VEILID_VERSION` in `build-push.sh` (and `nightly/build-push.sh` when applicable).
- Image tags: `ghcr.io/rich0/veilid:<version>` and `:latest`.
- Exposed ports: `5959/tcp` (client), `5050/tcp` + `5050/udp`.
- Data paths: `/var/db/veilid-server/{protected_store,table_store,block_store}`.

## MentisDB memory

Project memory uses **MentisDB**; Grok built-in memory remains available for optional global personal prefs only.

| Scope | System |
|-------|--------|
| This repo (decisions, lessons, conventions) | MentisDB chain `veilid` |
| Cross-project personal habits (optional) | Grok `~/.grok/memory/MEMORY.md` |

- **Chain:** `veilid` — always pass `chain_key="veilid"` on mentisdb MCP calls.
- **Agent:** `grok-build-cursor` — reuse; do not create new agent IDs without user approval.
- **Rules:** `.grok/rules/mentisdb.md` (auto-loaded) and `.grok/skills/mentisdb/SKILL.md` (repo skill override).
- Do not duplicate repo-specific facts in Grok workspace memory.

### Session startup (first MCP calls every session)

Run in order before repo search, file reads, or implementation (plan mode included):

```text
1. mentisdb_bootstrap
2. mentisdb_skill_md          # or read .grok/skills/mentisdb/SKILL.md
3. mentisdb_list_agents
4. mentisdb_recent_context
5. mentisdb_ranked_search
6. mentisdb_append            # Summary / Checkpoint before substantive work
```

### MCP tool reference — required and recommended fields

#### `mentisdb_bootstrap` (opens chain; safe on existing chains)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `content` | **yes** | Non-empty session summary, e.g. `"Session start in veilid; task: bump veilid-server to 0.5.5"` |
| `chain_key` | no (pass anyway) | `"veilid"` |
| `agent_id` | no (pass anyway) | `"grok-build-cursor"` |
| `agent_name` | no | `"veilid"` (optional) |
| `tags` | no | e.g. `["veilid", "bootstrap"]` |
| `concepts` | no | e.g. `["veilid", "docker"]` |
| `importance` | no | `0.8` for user-driven sessions |

Fails if `content` is missing or empty — retry with a non-empty string.

#### `mentisdb_list_agents` (confirm agent identity)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `chain_key` | no (pass anyway) | `"veilid"` |

Expect `grok-build-cursor` in the response. Do not call `mentisdb_upsert_agent` unless the user explicitly authorizes a new agent.

#### `mentisdb_recent_context` (resume where you left off)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `chain_key` | no (pass anyway) | `"veilid"` |
| `agent_id` | no (pass anyway) | `"grok-build-cursor"` |
| `last_n` | no | `20` |

#### `mentisdb_ranked_search` (recall before acting or writing)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `chain_key` | no (pass anyway) | `"veilid"` |
| `text` | no (use for recall) | Paraphrase of current task or proposed memory |
| `limit` | no | `10` |

#### `mentisdb_append` (persist durable memory)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `thought_type` | **yes** | e.g. `Summary`, `Decision`, `LessonLearned`, `Constraint`, `TaskComplete` |
| `content` | **yes** | Concise durable fact or checkpoint text |
| `chain_key` | no (pass anyway) | `"veilid"` |
| `agent_id` | no (pass anyway) | `"grok-build-cursor"` |
| `role` | no | `Checkpoint` for resumption summaries; `Memory` for facts |
| `refs` | no | Indices of related thoughts (link graph) |
| `tags` / `concepts` | no | Short labels for retrieval |
| `importance` | no | User facts ≈ `0.8`; assistant notes ≈ `0.2` |

Search with `mentisdb_ranked_search` before every append.

#### `mentisdb_upsert_agent` (one-time registry; owner-initiated only)

| Field | Required | Value for this repo |
|-------|----------|---------------------|
| `agent_id` | **yes** | `"grok-build-cursor"` |
| `chain_key` | no (pass anyway) | `"veilid"` |
| `display_name` | no | `"veilid"` |
| `description` | no | Free-form agent description |
| `status` | no | `"active"` |

Already registered on chain `veilid`. Agents must not self-register without user approval.

### Example bootstrap call

```json
{
  "chain_key": "veilid",
  "agent_id": "grok-build-cursor",
  "content": "Session start in veilid; task: update Dockerfile for new veilid-server release",
  "tags": ["veilid", "bootstrap"],
  "concepts": ["veilid", "docker"],
  "importance": 0.8
}
```

### Example checkpoint append

```json
{
  "chain_key": "veilid",
  "agent_id": "grok-build-cursor",
  "thought_type": "Summary",
  "role": "Checkpoint",
  "content": "Bumped VEILID_VERSION to 0.5.5 in build-push.sh; image builds cleanly.",
  "tags": ["checkpoint", "veilid"],
  "refs": [0]
}
```