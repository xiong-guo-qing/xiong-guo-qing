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

Reusable scripts have been moved to a separate repository:

- HTTPS: `https://github.com/xiong-guo-qing/scripts`
- SSH: `git@github.com:xiong-guo-qing/scripts.git`

This repository now focuses on rules and templates only.

### How to get the shared scripts

#### Clone the scripts repository

```bash
git clone git@github.com:xiong-guo-qing/scripts.git
```

Or via HTTPS:

```bash
git clone https://github.com/xiong-guo-qing/scripts.git
```

#### Pull updates later

```bash
cd scripts
git pull
```

### Included shared scripts

The shared scripts repository contains items such as:
- OpenClaw WSL startup / shutdown scripts
- Windows helper scripts
- `windows-java-service/` related maintenance scripts

## Notes

- `AI-RULES.md` is the global, tool-agnostic rule file
- `AI-PROJECT-RULES-template.md` is the per-project overlay template
- Shared scripts are maintained outside this rules repository to avoid duplication
