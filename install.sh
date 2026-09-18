#!/usr/bin/env bash
# install.sh: collega gli script di bin/ in ~/.local/bin tramite symlink.
# Idempotente: rieseguirlo dopo un git pull è sicuro.
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin"
dest_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"

mkdir -p "$dest_dir"

for src in "$src_dir"/*; do
  [ -f "$src" ] || continue
  name=$(basename "$src")
  dest="$dest_dir/$name"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  ok       $name (già collegato)"
    continue
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
      rm "$dest"                      # file identico: sostituibile senza perdere nulla
    else
      backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$backup"
      echo "  backup   $name -> $(basename "$backup")"
    fi
  fi

  ln -s "$src" "$dest"
  chmod +x "$src"
  echo "  linked   $name"
done

case ":$PATH:" in
  *":$dest_dir:"*) ;;
  *) echo
     echo "Attenzione: $dest_dir non è nel PATH. Aggiungi al tuo ~/.zshrc:"
     echo "  export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac
