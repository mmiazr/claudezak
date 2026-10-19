# claudezak — palavras personalizadas do spinner do Claude Code

Configuração pessoal do indicador de atividade ("spinner") do Claude Code: enquanto o Claude trabalha, em vez de "Thinking…" aparecem palavras como "Lavrando…", "Averbando…" ou "Dando fé…".

A lista fica em `.claude/settings.json`, na chave `spinnerVerbs` (modo `replace`), com 34 palavras:

| Grupo | Qtde. | Palavras |
|---|---|---|
| Pessoais | 9 | Michellando, Michellzando, Mi-pensando, Michellerando, Desmichellando, Remichellando, Michellcubando, Michellnado, Mi-matutando |
| Cartório (português) | 16 | Lavrando, Averbando, Carimbando, Reconhecendo firma, Protocolando, Autenticando, Selando, Registrando, Escriturando, Arquivando, Apostilando, Matriculando, Conferindo assinaturas, Expedindo certidão, Anotando à margem, Dando fé |
| Cartório (inglês) | 9 | Notarizing, Stamping, Certifying, Witnessing, Sealing, Filing, Attesting, Apostilling, Recording deeds |

## Alcance

- Dentro deste projeto, a lista vale automaticamente.
- Para valer em todos os projetos do computador, grave a mesma chave em `~/.claude/settings.json` (configuração geral do usuário). A configuração de um projeto prevalece sobre a geral.
- Reinicie o Claude Code depois de instalar.

## Instalação na configuração geral

### Windows (PowerShell)

```powershell
$ErrorActionPreference = 'Stop'
$dir  = Join-Path $HOME '.claude'
$file = Join-Path $dir 'settings.json'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$txt = ''
if (Test-Path $file) {
  Copy-Item $file "$file.bak.$(Get-Date -Format yyyyMMdd-HHmmss)"
  $txt = [IO.File]::ReadAllText($file)
}
if ([string]::IsNullOrWhiteSpace($txt)) { $atual = [pscustomobject]@{} } else { $atual = $txt | ConvertFrom-Json }
$url   = 'https://raw.githubusercontent.com/mmiazr/claudezak/main/.claude/settings.json'
$fonte = (Invoke-WebRequest -UseBasicParsing $url).Content | ConvertFrom-Json
$atual | Add-Member -NotePropertyName spinnerVerbs -NotePropertyValue $fonte.spinnerVerbs -Force
[IO.File]::WriteAllText($file, ($atual | ConvertTo-Json -Depth 100), (New-Object Text.UTF8Encoding $false))
Write-Host "Palavras gravadas: $(([IO.File]::ReadAllText($file) | ConvertFrom-Json).spinnerVerbs.verbs.Count)"
```

### macOS ou Linux (requer `jq`)

```bash
git clone https://github.com/mmiazr/claudezak.git
cd claudezak
./install.sh              # configuração geral (~/.claude/settings.json)
./install.sh --dry-run    # mostra o resultado sem gravar
./install.sh --uninstall  # remove a chave spinnerVerbs
```

O instalador altera só a chave `spinnerVerbs` e faz cópia de segurança (`settings.json.bak.<data>`) antes de gravar.

## Desfazer

Remova a chave `spinnerVerbs` do `settings.json` (ou rode `./install.sh --uninstall`). O Claude Code volta às palavras padrão.

## Origem

Fork de [code-418dotcom/claudezak](https://github.com/code-418dotcom/claudezak). Desta versão foram retirados a barra de status e as palavras do projeto original; ficou apenas a lista acima.
