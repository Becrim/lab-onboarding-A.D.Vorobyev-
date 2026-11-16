#!/bin/bash
# Модуль 2. Поиск дефектов в коде, связанном с облачной инфраструктурой.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/common.sh"

correct=0
total=5
score=0

printf "===============================================\n"
printf " МОДУЛЬ 2. РЕВЬЮ КОДА ОБЛАЧНОГО ПРИЛОЖЕНИЯ\n"
printf "===============================================\n"
printf "Для каждого фрагмента выберите тип дефекта.\n"
printf "За правильный ответ: +2 балла, за ошибочный: -1 балл.\n"
printf "Минимальное количество баллов — 0.\n\n"

show_options() {
    printf "1. Неинициализированная переменная\n"
    printf "2. Мёртвое присваивание\n"
    printf "3. Утечка ресурса\n"
    printf "4. Магическое число\n"
    printf "5. Отсутствие обработки ошибок\n"
}

check_answer() {
    local expected="$1"
    local explanation="$2"
    ask_number "Ваш ответ (1-5): " 1 5
    if [ "$REPLY" -eq "$expected" ]; then
        printf "Верно! %s\n" "$explanation"
        correct=$((correct + 1))
        score=$((score + 2))
    else
        printf "Неверно. Правильный ответ: %s. %s\n" "$expected" "$explanation"
        score=$((score - 1))
        [ "$score" -lt 0 ] && score=0
    fi
    printf "Текущий счёт: %s\n\n" "$score"
}

printf "Фрагмент 1. Получение состояния виртуальной машины:\n"
cat <<'SNIPPET'
def get_instance_status(client, instance_id):
    if instance_id:
        status = client.get_instance(instance_id).status
    return status
SNIPPET
printf "Какой дефект присутствует?\n"
show_options
check_answer 1 "Если instance_id пустой, переменная status не будет создана."

printf "Фрагмент 2. Формирование конфигурации региона:\n"
cat <<'SNIPPET'
def select_region(config):
    region = "ru-central1"
    region = config.get("region", "ru-central1")
    return region
SNIPPET
printf "Какой дефект присутствует?\n"
show_options
check_answer 2 "Первое значение region сразу перезаписывается и не используется."

printf "Фрагмент 3. Загрузка резервной копии из облака:\n"
cat <<'SNIPPET'
def download_backup(client, backup_id, path):
    stream = client.download_backup(backup_id)
    with open(path, "wb") as file:
        for chunk in stream:
            file.write(chunk)
SNIPPET
printf "Какой дефект присутствует?\n"
show_options
check_answer 3 "Поток stream не закрывается после чтения."

printf "Фрагмент 4. Проверка нагрузки процессора:\n"
cat <<'SNIPPET'
def should_scale(cpu_percent):
    if cpu_percent > 85:
        return True
    return False
SNIPPET
printf "Какой дефект присутствует?\n"
show_options
check_answer 4 "Порог 85 задан прямо в коде; его лучше вынести в именованную константу или настройку."

printf "Фрагмент 5. Создание облачного сервера:\n"
cat <<'SNIPPET'
def create_server(client, settings):
    server = client.servers.create(settings)
    return server.id
SNIPPET
printf "Какой дефект присутствует?\n"
show_options
check_answer 5 "Не предусмотрена обработка ошибок API или отказа облачного сервиса."

accuracy=$((correct * 100 / total))
if [ "$accuracy" -ge 80 ]; then
    level="Senior Reviewer"
elif [ "$accuracy" -ge 60 ]; then
    level="Middle Reviewer"
else
    level="Junior Reviewer"
fi

printf "%s\n" "--- Итоговый отчёт ревью ---"
printf "Просмотрено фрагментов: %s\n" "$total"
printf "Правильных ответов: %s\n" "$correct"
printf "Точность: %s%%\n" "$accuracy"
printf "Количество баллов: %s\n" "$score"
printf "Уровень ревьюера: %s\n" "$level"

{
    printf "Результат ревью кода: %s из %s правильных ответов, точность %s%%.\n" "$correct" "$total" "$accuracy"
    printf "Уровень ревьюера: %s (баллы: %s).\n" "$level" "$score"
} > "$STATE_DIR/chapter2.txt"

pause_screen
