# AGENTS.md — dotfiles

Repo **pubblico**. Chiunque su internet legge ogni commit, e la cronologia git resta
consultabile anche dopo che un file viene cancellato. Tutto ciò che finisce qui va
considerato pubblicato per sempre.

## Regola primaria

Non committare mai un valore segreto o specifico di una macchina. In caso di dubbio su un
file, non aggiungerlo: chiedi all'utente.

Sono segreti anche quando sembrano innocui:

- token e chiavi API (`gho_`, `ghp_`, `sk-`, `AKIA…`), password, cookie di sessione
- chiavi private SSH o GPG, certificati, `*.pem`, `*.key`
- `.env`, `.npmrc`, `.netrc`, `.aws/credentials`, `.config/gh/hosts.yml`
- hostname e IP dell'infrastruttura di casa o aziendale, nomi di client, URL interni
- percorsi che rivelano struttura privata, indirizzi email personali diversi da quelli già
  pubblici nei commit

## Prima di ogni commit

1. `git status` e `git diff --staged`: leggi **ogni riga** aggiunta, non solo i nomi dei file.
2. Verifica che nessun file nuovo rientri nelle categorie sopra.
3. Controlla che `.gitignore` copra già i pattern rischiosi; se aggiungi un tipo di file
   nuovo che potrebbe contenere segreti, estendi `.gitignore` nello stesso commit.
4. Non usare mai `git add -A` o `git add .` senza aver prima ispezionato `git status`.
5. Non usare `git add -f` per forzare un file ignorato: se `.gitignore` lo esclude, c'è un
   motivo.

## Come gestire la roba per-macchina

Nel repo va solo ciò che è identico su ogni macchina. Il resto va in file `*.local`, esclusi
da `.gitignore` e non versionati — per esempio un `~/.zshrc.local` letto in fondo al `~/.zshrc`
versionato. Se uno script ha bisogno di un valore segreto, leggilo da variabile d'ambiente o
da un file `*.local`; non scriverlo nel sorgente, nemmeno come default o come esempio
realistico.

Negli esempi di documentazione usa segnaposto evidenti (`<TOKEN>`, `esempio.com`), mai valori
copiati da una configurazione reale.

## Se un segreto è già stato committato

Fermati e dillo subito all'utente. Non limitarti a un commit che rimuove il file: il valore
resta nella cronologia e va considerato compromesso. Il segreto va **ruotato** alla fonte
(rigenerare il token, sostituire la chiave), e solo dopo si valuta la riscrittura della storia.

## Aggiungere uno script a `bin/`

- shebang `#!/usr/bin/env bash` e `set -euo pipefail`
- commento iniziale con una riga di descrizione e la riga d'uso
- verifica le dipendenze esterne all'avvio, con un messaggio che dica come installarle
- rendilo eseguibile (`chmod +x`); `install.sh` lo collega da solo, non va modificato
- documentalo nel `README.md` con dipendenze e sintassi
