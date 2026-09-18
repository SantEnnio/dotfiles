# dotfiles

Setup personale della shell: script in `bin/`, collegati in `~/.local/bin` via symlink.

## Installazione su una macchina nuova

```sh
gh repo clone SantEnnio/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` è idempotente: rieseguilo dopo ogni `git pull`. Se in `~/.local/bin` esiste già
un file con lo stesso nome e contenuto diverso, viene salvato come `.bak.<timestamp>` invece
di essere sovrascritto.

Serve che `~/.local/bin` sia nel `PATH`; lo script avvisa se non lo è.

## Script

### `clone-repo [filtro]`

Elenca con `fzf` tutte le repo GitHub visibili all'account loggato in `gh` (owner,
collaboratore, membro di organizzazione), ordinate per push più recente, e clona quella scelta
nella cartella corrente. Le private sono marcate 🔒 e il pannello di anteprima mostra
`gh repo view`.

Dipendenze: `gh`, `fzf`, `git` — su macOS `brew install gh fzf`, poi `gh auth login`.

## Convenzioni

Nel repo va solo ciò che è uguale su ogni macchina. Token, chiavi, host interni e impostazioni
specifiche di una macchina restano fuori: mettili in file `*.local` (esclusi da `.gitignore`),
per esempio un `~/.zshrc.local` letto in fondo al tuo `~/.zshrc`.
