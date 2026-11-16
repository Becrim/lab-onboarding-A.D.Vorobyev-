#!/bin/bash
# Общие функции для модулей лабораторной работы.

STATE_DIR="${SCRIPT_DIR}/.lab_state"
mkdir -p "$STATE_DIR"

ask_number() {
    local prompt="$1"
    local min_value="$2"
    local max_value="$3"
    local value

    while true; do
        printf "%s" "$prompt"
        IFS= read -r value
        if [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -ge "$min_value" ] && [ "$value" -le "$max_value" ]; then
            REPLY="$value"
            return 0
        fi
        printf "Введите целое число от %s до %s.\n" "$min_value" "$max_value"
    done
}

pause_screen() {
    printf "\nНажмите Enter, чтобы продолжить..."
    IFS= read -r _
}
