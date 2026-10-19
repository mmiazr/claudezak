# Memory

## Now
- claudezak é a configuração pessoal do spinner do Claude Code de Michell: 34 palavras (pessoais + tema cartório PT/EN) em `.claude/settings.json` → `spinnerVerbs`.

## Project Profile
- Type: configuração do Claude Code
- Language: JSON (settings) + Bash (install.sh)
- Framework: none

## Open Threads
- PR para o original (code-418dotcom/claudezak#1): fechar, pois o fork divergiu (barra de status e skills genéricas removidas).

## Recent Decisions
- 161026 — Lista de palavras substituída pelas pessoais e de cartório (PRs #1 e #2).
- 161026 — Instalação na configuração geral do Windows feita por PowerShell, gravando só `spinnerVerbs`.
- 191026 — Limpeza geral: removidos a barra de status obscena (`statusLine` + `bin/claudezak-status.sh`), as 31 categorias de skills genéricas do Claudify e a memória/diário do autor original. `install.sh` passou a tratar só `spinnerVerbs`.

## Blockers
- (none)

## Key Facts
- `spinnerVerbs.mode = "replace"` substitui as palavras padrão; `"append"` soma às padrão.
- A configuração do projeto prevalece sobre `~/.claude/settings.json`.
- O repositório é público: não guardar dados da serventia nem de partes.
