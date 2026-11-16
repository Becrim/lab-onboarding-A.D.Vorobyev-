#!/bin/bash
# Главное меню лабораторной работы. Объединяет три независимых модуля.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

make_report() {
    local report="$SCRIPT_DIR/report.txt"
    {
        printf "ИТОГОВЫЙ ОТЧЁТ ЛАБОРАТОРНОЙ РАБОТЫ № 2\n"
        printf "Вариант 4. Выбор облачной платформы для стартапа\n"
        printf "Дата формирования: %s\n\n" "$(date '+%d.%m.%Y %H:%M:%S')"
        for result_file in chapter1.txt chapter2.txt chapter3.txt; do
            if [ -f "$STATE_DIR/$result_file" ]; then
                cat "$STATE_DIR/$result_file"
                printf "\n"
            else
                printf "Результат %s отсутствует: соответствующий модуль ещё не запускался.\n\n" "$result_file"
            fi
        done
    } > "$report"
    printf "Итоговый отчёт сохранён: %s\n" "$report"
}

run_all() {
    printf "\nЗапуск модуля 1 из 3...\n"
    "$SCRIPT_DIR/chapter1.sh"
    printf "\nЗапуск модуля 2 из 3...\n"
    "$SCRIPT_DIR/chapter2.sh"
    printf "\nЗапуск модуля 3 из 3...\n"
    "$SCRIPT_DIR/chapter3.sh"
    printf "\nВсе модули завершены.\n"
    make_report
    pause_screen
}

while true; do
    printf "\n===============================================\n"
    printf " СИСТЕМА АНАЛИЗА ОБЛАЧНОЙ ПЛАТФОРМЫ — ВАРИАНТ 4\n"
    printf "===============================================\n"
    printf "1. Модуль выбора облачной платформы\n"
    printf "2. Модуль инспекции кода\n"
    printf "3. Модуль сравнительного анализа WSM\n"
    printf "4. Запустить все модули последовательно\n"
    printf "5. Сформировать report.txt по имеющимся результатам\n"
    printf "6. Выход\n\n"
    ask_number "Ваш выбор (1-6): " 1 6
    case "$REPLY" in
        1) "$SCRIPT_DIR/chapter1.sh" ;;
        2) "$SCRIPT_DIR/chapter2.sh" ;;
        3) "$SCRIPT_DIR/chapter3.sh" ;;
        4) run_all ;;
        5) make_report; pause_screen ;;
        6) printf "Работа завершена.\n"; exit 0 ;;
    esac
done
