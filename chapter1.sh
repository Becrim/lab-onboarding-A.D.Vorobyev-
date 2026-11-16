#!/bin/bash
# Модуль 1. Выбор облачной платформы для стартапа (вариант 4).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

printf "===============================================\n"
printf " МОДУЛЬ 1. ВЫБОР ОБЛАЧНОЙ ПЛАТФОРМЫ\n"
printf "===============================================\n"
printf "Кандидаты: Yandex Cloud, Selectel, Timeweb Cloud\n"
printf "Сценарий: MVP веб-приложения с ожидаемым ростом нагрузки.\n\n"
printf "Ответы формируют условный профиль проекта. Это учебная\n"
printf "модель, а не готовая оценка актуальных тарифов провайдеров.\n\n"

yandex=0
selectel=0
timeweb=0

printf "Вопрос 1. Что важнее на этапе запуска MVP?\n"
printf "1. Быстро начать работу с минимумом настройки\n"
printf "2. Использовать широкий набор облачных и управляемых сервисов\n"
printf "3. Получить больше контроля над инфраструктурой\n"
ask_number "Ваш выбор (1-3): " 1 3
case "$REPLY" in
    1) timeweb=$((timeweb + 3)); yandex=$((yandex + 2)); selectel=$((selectel + 1)) ;;
    2) yandex=$((yandex + 3)); selectel=$((selectel + 2)); timeweb=$((timeweb + 1)) ;;
    3) selectel=$((selectel + 3)); yandex=$((yandex + 2)); timeweb=$((timeweb + 1)) ;;
esac

printf "\nВопрос 2. Какой характер нагрузки ожидается?\n"
printf "1. Умеренная и относительно стабильная нагрузка\n"
printf "2. Переменная нагрузка с постепенным ростом\n"
printf "3. Высокая нагрузка и необходимость тонкой настройки ресурсов\n"
ask_number "Ваш выбор (1-3): " 1 3
case "$REPLY" in
    1) timeweb=$((timeweb + 3)); selectel=$((selectel + 2)); yandex=$((yandex + 1)) ;;
    2) yandex=$((yandex + 3)); timeweb=$((timeweb + 2)); selectel=$((selectel + 1)) ;;
    3) selectel=$((selectel + 3)); yandex=$((yandex + 2)); timeweb=$((timeweb + 1)) ;;
esac

printf "\nВопрос 3. Какой опыт администрирования есть у команды?\n"
printf "1. Небольшой, желательно упростить обслуживание\n"
printf "2. Есть опыт работы с облачными сервисами\n"
printf "3. Есть опыт DevOps и самостоятельной настройки инфраструктуры\n"
ask_number "Ваш выбор (1-3): " 1 3
case "$REPLY" in
    1) timeweb=$((timeweb + 3)); yandex=$((yandex + 2)); selectel=$((selectel + 1)) ;;
    2) yandex=$((yandex + 3)); timeweb=$((timeweb + 2)); selectel=$((selectel + 1)) ;;
    3) selectel=$((selectel + 3)); yandex=$((yandex + 2)); timeweb=$((timeweb + 1)) ;;
esac

printf "\nВопрос 4. Какой подход к бюджету ближе проекту?\n"
printf "1. Начать с минимально необходимой конфигурации\n"
printf "2. Сбалансировать затраты и возможности для роста\n"
printf "3. Приоритет — гибкость архитектуры и управление ресурсами\n"
ask_number "Ваш выбор (1-3): " 1 3
case "$REPLY" in
    1) timeweb=$((timeweb + 3)); yandex=$((yandex + 2)); selectel=$((selectel + 1)) ;;
    2) yandex=$((yandex + 3)); timeweb=$((timeweb + 2)); selectel=$((selectel + 1)) ;;
    3) selectel=$((selectel + 3)); yandex=$((yandex + 2)); timeweb=$((timeweb + 1)) ;;
esac

max_score=$yandex
[ "$selectel" -gt "$max_score" ] && max_score=$selectel
[ "$timeweb" -gt "$max_score" ] && max_score=$timeweb

tied=()
[ "$yandex" -eq "$max_score" ] && tied+=("Yandex Cloud")
[ "$selectel" -eq "$max_score" ] && tied+=("Selectel")
[ "$timeweb" -eq "$max_score" ] && tied+=("Timeweb Cloud")

printf "\n--- Результаты профилирования ---\n"
printf "Yandex Cloud: %s баллов\n" "$yandex"
printf "Selectel: %s баллов\n" "$selectel"
printf "Timeweb Cloud: %s баллов\n" "$timeweb"

if [ "${#tied[@]}" -eq 1 ]; then
    recommendation="${tied[0]}"
else
    printf "\nПолучилась ничья. Выберите итоговую рекомендацию из лидеров:\n"
    i=1
    for platform in "${tied[@]}"; do
        printf "%s. %s\n" "$i" "$platform"
        i=$((i + 1))
    done
    ask_number "Ваш выбор (1-${#tied[@]}): " 1 "${#tied[@]}"
    recommendation="${tied[$((REPLY - 1))]}"
fi

printf "\nРекомендация по учебной модели: %s\n" "$recommendation"
printf "Важно: перед реальным внедрением сравните текущие тарифы,\n"
printf "регионы доступности, SLA, безопасность и нужные сервисы.\n"

{
    printf "Рекомендация по выбору облачной платформы: %s\n" "$recommendation"
    printf "Баллы: Yandex Cloud — %s; Selectel — %s; Timeweb Cloud — %s.\n" "$yandex" "$selectel" "$timeweb"
} > "$STATE_DIR/chapter1.txt"

pause_screen
