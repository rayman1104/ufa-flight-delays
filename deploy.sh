#!/bin/bash
# Пересобирает страницу и публикует её на GitHub Pages.
set -e
SRC="$HOME/ufa-flights"
cd "$SRC"
python3 prep_extra.py          # агрегаты для разделов про БПЛА и Стамбул
python3 build_month.py         # сам отчёт (фрагмент)
python3 wrap.py                # обёртка в самодостаточный HTML
cp "$SRC/ufa-delays-jul11-aug10-2026.html" "$SRC/site/index.html"
cd "$SRC/site"
git add index.html README.md
git commit -q -m "${1:-обновление отчёта}" || { echo "нечего коммитить"; exit 0; }
git push -q origin main
echo "опубликовано: https://rayman1104.github.io/ufa-flight-delays/"
