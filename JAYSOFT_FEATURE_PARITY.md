# Feature parity ledger

Baseline: OpenAI Codex CLI `0.144.1`, Claude Code documentation reviewed 2026-07-13, and JaySoft LocalAI's Linux/Qwen configuration. Status values are **inherited**, **added**, **planned**, or **not reproducible**.

## Core agent and terminal

| Capability | Status | Notes |
| --- | --- | --- |
| Interactive TUI, streaming, multiline input, cancellation | inherited | Codex TUI; local Ollama provider |
| Non-interactive execution, stdin, JSONL, response schema | inherited | `localai exec` |
| Repository search/read/edit/patch/shell/Git/test workflows | inherited | Model-selected tools |
| Plan, review, task tracking, context compaction | inherited | Subject to local-model quality |
| Images | inherited interface | Default Qwen Coder model is text-only |
| Visible runtime startup and model management | added | Project-managed Ollama scripts |
| Checkpoints and file rewind matching Claude Code | planned | Sessions and Git recovery exist; pre-edit rewind UX remains |

## Safety and state

| Capability | Status | Notes |
| --- | --- | --- |
| Read-only, workspace-write, and full-access sandbox modes | inherited | Linux sandbox implementation |
| Approval policies and executable rules | inherited | Default is on-request/workspace-write |
| Persistent sessions, resume, fork, archive, delete | inherited | Stored below `~/.localai/codex` |
| User/project instructions and `AGENTS.md` hierarchy | inherited | Lazy bounded context |
| `CLAUDE.md` compatibility | planned | Compatibility loader and precedence tests required |
| Memory and profiles | inherited | Disabled/experimental features stay opt-in |

## Extensions and coordination

| Capability | Status | Notes |
| --- | --- | --- |
| Skills, plugins, hooks | inherited | Codex-native formats |
| MCP client/server, prompts, resources, tools | inherited | Local and explicitly configured remote servers |
| Multi-agent work and background tasks | inherited | Performance is limited by one small CPU model |
| Worktree isolation | inherited | Git repositories only |
| Claude plugin/agent file compatibility | planned | Import adapter, not a claim of binary compatibility |
| Web search and network integrations | inherited, opt-in | Disabled in generated default config |
| Shell completion, doctor, app/exec server, SDK surfaces | inherited | Branding cleanup is ongoing |

## Not reproducible locally

- Claude, GPT, and hosted Codex reasoning quality cannot be reproduced by a 3B local model.
- Hosted cloud tasks, subscription authentication, managed SaaS connectors, proprietary image generation, and hosted computer-use services are not local features.
- Vision requires a separately configured vision model and additional memory.
- Parallel agents share the same two CPU cores and will usually reduce throughput on the target laptop.

## Acceptance gates

- A prompt prints progress immediately; cancellation exits without a Python/Rust traceback.
- Cold model readiness completes or returns an actionable error within 120 seconds.
- A warm trivial prompt completes within 30 seconds on the target laptop.
- Read-only and workspace-write sandboxes reject writes outside authorized roots, including symlink escapes.
- Install, upgrade, relocation, stop, and uninstall flows are idempotent.
- Agent benchmarks report model failures rather than converting interface availability into a false capability claim.

## Research sources

- [OpenAI Codex source and Apache-2.0 license](https://github.com/openai/codex)
- [Claude Code CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage)
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code permissions](https://code.claude.com/docs/en/permissions)
- [Claude Code checkpoints](https://code.claude.com/docs/en/checkpointing)
- [Claude Code plugins](https://code.claude.com/docs/en/plugins)
- [Claude Code agents and worktrees](https://code.claude.com/docs/en/agents)
- [Qwen2.5-Coder model family](https://qwenlm.github.io/blog/qwen2.5-coder-family/)
