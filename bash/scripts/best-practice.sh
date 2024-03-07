#!/usr/bin/env bash
declare -a lunch_options
work_dir=$(dirname "$(realpath $(basename -- "$0"))")
food_places="${work_dir}/food_places.txt"
readonly FILE_NOT_FOUND="150"
readonly NO_OPTIONS_LEFT="180"

terminate() {
        local -r msg="${1}"
        local -r code="${2:-150}"
        echo "${msg}" >&2
        exit "${code}"
}

if [[ ! -f "${food_places}" ]]; then
        terminate "Error: food_places.txt file doesn't exist" ${FILE_NOT_FOUND}
fi

function fillout_array() {
        mapfile -t lunch_options < "${food_places}"

        if [[ "${#lunch_options[@]}" -eq 0 ]]; then
                terminate "Error: No food options left. Please add food options to food_places.txt" ${NO_OPTIONS_LEFT}
        fi
}

update_options() {
        if [[ "${#lunch_options[@]}" -eq 0 ]]; then
                : > "${food_places}"
        else
                printf "%s\n" "${lunch_options[@]}" > "${food_places}"
        fi
}

fillout_array

index=$((RANDOM % "${#lunch_options[@]}"))

echo "${lunch_options[${index}]}"

unset "lunch_options[${index}]"

update_options
