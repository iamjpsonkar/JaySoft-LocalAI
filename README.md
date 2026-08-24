# JaySoft LocalAI

`localai` is a local-first coding agent for Linux. It combines the mature, Apache-2.0 Codex CLI agent runtime with a project-managed Ollama service and a small coding model that can run on modest hardware.

The default model is `qwen2.5-coder:3b`. Inference, sessions, repository inspection, edits, commands, sandboxing, skills, plugins, hooks, and local MCP servers run on the machine. Network-backed tools remain optional.

## Install

```bash
./scripts/install.sh
localai doctor
localai
```

The installer downloads a pinned Ollama runtime and approximately 1.9 GB of model weights, writes local defaults under `~/.localai`, and installs `~/.local/bin/localai`.

## Commands

```bash
localai                         # interactive agent
localai exec "explain this"    # non-interactive task
localai review                  # code review
localai resume                  # resume a session
localai models                  # installed local models
localai benchmark               # cold/warm inference data
localai stop                    # stop managed Ollama
localai mcp --help              # MCP configuration
localai plugin --help           # plugin management
```

Set `LOCALAI_MODEL`, `OLLAMA_CONTEXT_LENGTH`, or `LOCALAI_HOME` to override the defaults. Core inference is offline after installation. Web search and remote MCP require explicit configuration and network access.

## Hardware profile

The defaults target an Intel i5-7200U with 11 GiB RAM and no discrete GPU. An 8K context is a compromise between repository context, memory, and latency. The first model load can take up to two minutes; `Ctrl+C` must always cancel cleanly.

## Scope and attribution

See [JAYSOFT_FEATURE_PARITY.md](JAYSOFT_FEATURE_PARITY.md) for the feature matrix and explicit limitations.

This project is a fork of [OpenAI Codex CLI](https://github.com/openai/codex) at tag `rust-v0.144.1`. The upstream source and this fork are licensed under [Apache-2.0](LICENSE). OpenAI and Codex are trademarks of their respective owner; JaySoft LocalAI is an independent project and is not endorsed by OpenAI or Anthropic.
