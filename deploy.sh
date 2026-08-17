#!/bin/bash
# Пересобирает страницу и публикует её на GitHub Pages.
set -e
# Исходники лежат на уровень выше site/ — раньше путь был прибит к ~/ufa-flights,
# а этого каталога уже нет.
SRC="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SRC"
python3 prep_all.py            # все агрегаты из выгрузки FR24 за окно отчёта
python3 prep_extra.py          # разделы про БПЛА, Стамбул и перелом 30 июля
python3 build_month.py         # сам отчёт (фрагмент)
python3 wrap.py                # обёртка в самодостаточный HTML
cp "$SRC/ufa-delays.html" "$SRC/site/index.html"
cd "$SRC/site"
git add index.html README.md
git commit -q -m "${1:-обновление отчёта}" || { echo "нечего коммитить"; exit 0; }
git push -q origin main
echo "опубликовано: https://rayman1104.github.io/ufa-flight-delays/"
