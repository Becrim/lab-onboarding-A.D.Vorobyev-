#!/bin/bash
# Модуль 3. Сравнение облачных платформ методом взвешенной суммы (WSM).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

criteria=(
    "Предсказуемость затрат"
    "Масштабируемость"
    "Наличие управляемых сервисов"
    "Контроль над инфраструктурой"
    "Простота запуска и администрирования"
)
weights=()
yandex=()
selectel=()
timeweb=()

printf "===============================================\n"
printf " МОДУЛЬ 3. СРАВНИТЕЛЬНЫЙ АНАЛИЗ (WSM)\n"
printf "===============================================\n"
printf "Платформы: Yandex Cloud, Selectel, Timeweb Cloud\n"
printf "Назначьте веса пяти критериям. Сумма должна быть равна 100.\n"
printf "Чем важнее критерий для проекта, тем выше его вес.\n\n"

while true; do
    weights=()
    weight_sum=0
    for i in 0 1 2 3 4; do
        ask_number "Вес: ${criteria[$i]} (0-100): " 0 100
        weights+=("$REPLY")
        weight_sum=$((weight_sum + REPLY))
    done
    if [ "$weight_sum" -eq 100 ]; then
        break
    fi
    printf "Сумма весов равна %s, а должна быть 100. Введите веса заново.\n\n" "$weight_sum"
done

printf "\nТеперь оцените каждую платформу по каждому критерию от 1 до 5.\n"
printf "1 — подходит слабо, 5 — подходит отлично. Оценки задаются\n"
printf "самостоятельно на основе требований проекта и изученных характеристик.\n\n"

for i in 0 1 2 3 4; do
    printf "Критерий: %s (вес %s)\n" "${criteria[$i]}" "${weights[$i]}"
    ask_number "  Yandex Cloud (1-5): " 1 5
    yandex+=("$REPLY")
    ask_number "  Selectel (1-5): " 1 5
    selectel+=("$REPLY")
    ask_number "  Timeweb Cloud (1-5): " 1 5
    timeweb+=("$REPLY")
    printf "\n"
done

yandex_score=0
selectel_score=0
timeweb_score=0
for i in 0 1 2 3 4; do
    yandex_score=$((yandex_score + weights[$i] * yandex[$i]))
    selectel_score=$((selectel_score + weights[$i] * selectel[$i]))
    timeweb_score=$((timeweb_score + weights[$i] * timeweb[$i]))
done

yandex_display=$(awk -v value="$yandex_score" 'BEGIN { printf "%.2f", value / 100 }')
selectel_display=$(awk -v value="$selectel_score" 'BEGIN { printf "%.2f", value / 100 }')
timeweb_display=$(awk -v value="$timeweb_score" 'BEGIN { printf "%.2f", value / 100 }')

printf "\n================ МАТРИЦА РЕШЕНИЙ ================\n"
printf "%-43s %5s %10s %10s %12s\n" "Критерий" "Вес" "Yandex" "Selectel" "Timeweb"
printf "%s\n" "--------------------------------------------------------------------------------"
for i in 0 1 2 3 4; do
    printf "%-43s %4s%% %10s %10s %12s\n" "${criteria[$i]}" "${weights[$i]}" "${yandex[$i]}" "${selectel[$i]}" "${timeweb[$i]}"
done
printf "%s\n" "--------------------------------------------------------------------------------"
printf "%-43s %5s %10s %10s %12s\n" "ИТОГОВЫЙ БАЛЛ (из 5)" "100%" "$yandex_display" "$selectel_display" "$timeweb_display"
printf "==================================================\n"

max_score=$yandex_score
[ "$selectel_score" -gt "$max_score" ] && max_score=$selectel_score
[ "$timeweb_score" -gt "$max_score" ] && max_score=$timeweb_score
winners=()
[ "$yandex_score" -eq "$max_score" ] && winners+=("Yandex Cloud")
[ "$selectel_score" -eq "$max_score" ] && winners+=("Selectel")
[ "$timeweb_score" -eq "$max_score" ] && winners+=("Timeweb Cloud")

if [ "${#winners[@]}" -eq 1 ]; then
    winner="${winners[0]}"
    printf "Победитель сравнительного анализа: %s\n" "$winner"
else
    winner="Ничья: ${winners[*]}"
    printf "Одинаковый наибольший балл получили: %s\n" "${winners[*]}"
fi
printf "Формула: S = сумма (вес критерия × оценка платформы).\n"
printf "При сумме весов 100 итоговый балл нормирован к шкале 1-5.\n"

{
    printf "Победитель сравнительного анализа WSM: %s.\n" "$winner"
    printf "Итоговые баллы: Yandex Cloud — %s; Selectel — %s; Timeweb Cloud — %s (из 5).\n" "$yandex_display" "$selectel_display" "$timeweb_display"
} > "$STATE_DIR/chapter3.txt"

pause_screen
