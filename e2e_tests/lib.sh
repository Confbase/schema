#!/bin/bash

run_test() {
    fn="$1"

    printf "Running '$fn'..."
    if [ ! "$(type -t $fn)" = "function" ]; then
        printf "FAIL. '$fn' is not a function in the test scripts\n"
        exit 1
    fi
    eval "$fn"

    if [ ! "$status" = "$expect_status" ]; then
        printf "FAIL. Expected status $expect_status, but got $status\n"
        printf "Output:\n$output"
        exit 1
    fi

    if [ "$expect_either_or" = 'true' ]; then
        diffe="$(diff <(printf "%s" "$expect_either") <(printf "%s" "$output"))"
        diffo="$(diff <(printf "%s" "$expect_or")     <(printf "%s" "$output"))"
        if [ ! -z "$diffe" ] && [ ! -z "$diffo" ]; then
            printf "FAIL. Expected either:\n%s\n" "$expect_either"
            printf "or:\n%s\n" "$expect_or"
            printf "but got:\n%s\n" "$output"
            printf "diff (either):\n%s\n" "$diffe"
            printf "diff (or):\n%s\n" "$diffo"
            exit 1
        fi
        expect_either_or='false'
    else
        difference="$(diff <(printf "%s" "$expect") <(printf "%s" "$output"))"
        if [ ! -z "$difference" ]; then
            printf "FAIL. Expected output:\n%s\nBut got:\n%s" "$expect" "$output"
            exit 1
        fi
    fi
    printf "OK\n"
}
