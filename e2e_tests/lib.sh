#!/bin/bash

run_test() {
    fn="$1"

    printf "Running '$fn'..."
    eval "$fn"

    if [ ! "$status" = "$expect_status" ]; then
        printf "FAIL. Expected status $expect_status, but got $status\n"
        printf "Output:\n$output"
        exit 1
    fi

    difference="$(diff <(printf "%s" "$expect") <(printf "%s" "$output"))"
    if [ ! -z "$difference" ]; then
        printf "FAIL. Expected this output:\n%s\nBut got:\n%s" "$expect" "$output"
        exit 1
    fi
    printf "OK\n"
}
