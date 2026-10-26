#!/bin/bash
# Практическая работа: Диагностика клиентского компьютера (macOS)
# Автор: Воробьев Андрей   Дата: 26.10.2026

REPORT="$(cd "$(dirname "$0")" && pwd)/pc_report.txt"

{
echo "Диагностика компьютера"
echo "=============================="
echo

# --- Операционная система ---
echo "Операционная система"
echo "Название: $(sw_vers -productName)"
echo "Версия: $(sw_vers -productVersion)"
echo "------------------------------"

# --- Процессор ---
echo "Процессор"
sysctl -n machdep.cpu.brand_string
echo "------------------------------"

# --- Оперативная память (в ГБ) ---
PAGE=$(sysctl -n hw.pagesize)
FREE_PAGES=$(vm_stat | awk '/Pages free|Pages inactive/ {gsub("\\.","",$NF); s+=$NF} END {print s}')
echo "Оперативная память"
echo "Всего памяти: $(( $(sysctl -n hw.memsize) / 1073741824 )) ГБ"
echo "Свободно памяти: $(( FREE_PAGES * PAGE / 1073741824 )) ГБ"
echo "------------------------------"

# --- Диск ---
echo "Диск"
df -g / | awk 'NR==2 {print "Всего: " $2 " ГБ\nСвободно: " $4 " ГБ"}'
echo "------------------------------"

# --- Установленные программы ---
echo "Установленные программы"
ls /Applications | sed 's/\.app$//'
} | tee "$REPORT"

echo
echo "Отчёт сохранён"