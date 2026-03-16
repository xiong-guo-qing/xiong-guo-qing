# xiong-guo-qing

This repository stores general rules and guidance for AI coding assistants.

## Main documents

- `AI-RULES.md` — the single source of truth for general AI coding rules, workflow, safety, and memory model
- `AI-PROJECT-RULES-template.md` — a project-level template for repository-specific context, boundaries, and conventions

## Memory model

This repo uses a two-layer memory model:

- **Short-term memory**: for conversation state, temporary constraints, debugging progress, and task process notes
- **Long-term memory (`basic-memory`)**: for stable, verified, reusable knowledge

Recommended short-term memory structure inside a project:

```text
memory/
  inbox.md
  daily/
  tasks/
```

## Scripts

Reusable scripts are being moved into a separate repository:

- `https://github.com/xiong-guo-qing/scripts`

This repository should primarily keep rules and templates.
Project-specific repositories can reference shared scripts from the dedicated scripts repository.

### OpenClaw WSL scripts

Related startup / shutdown scripts are intended to live in the shared scripts repository, including:
- `start-openclaw-wsl.sh`
- `start-openclaw-wsl.bat`
- `stop-openclaw-wsl.sh`
- `stop-openclaw-wsl.bat`

### Notes

- `AI-RULES.md` is the global, tool-agnostic rule file
- `AI-PROJECT-RULES-template.md` is the per-project overlay template
- Shared scripts are better maintained outside this rules repository
