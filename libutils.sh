#!/bin/bash
# [MIT License] Copyright (C) 2024  Michel Novus

## --------------------------------------------------------------------
## `libutils.sh` is a shell library that defines useful commands 
## that i often use in my Bash scripts.
##
## To use this library just run script and the funtion name with
## its nedded arguments, just like:
##     /path/to/libutils.sh {function_name} {argument ...}
##
## (*) The `libutils.sh` script must be executable.
## --------------------------------------------------------------------

## Compare two version format string, first version is the minimal
## required and second version is the comparative value.
## If first <= second return 0 else return 1.
## Use: $0 version_cmp {MIN_VER} {TEST_VER} -> {0 | 1}
function version_cmp {
    minimal_ver="$1"
    compare_ver="$2"
    sort_result=$(\
        printf '%s\n' "$minimal_ver" "$compare_ver" | sort --version-sort | head -n 1\
    )
    if [[ "$sort_result" != "$minimal_ver" ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

## Find and return first ocurrence of Semantic Version string inside of
## provided STRING.
## If does not find anything SemVer string, exit with error status.
## Use: $0 extract_semver {STRING} -> {SemVer_string}
function extract_semver {
    input_string="$1"
    first_version=$(grep -oP \
        '(?P<major>0|[1-9]\d*)\.(?P<minor>0|[1-9]\d*)\.(?P<patch>0|[1-9]\d*)(?:-(?P<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?' \
        <<< "$input_string" | head -n 1)
    if [[ -z $first_version ]]
    then
        exit 1
    else
        echo "$first_version"
    fi
}

## Checks if the current version of the program installed on the host 
## is equal to or lower than the one given by the argument.
## Use: $0 check_version_app {PROG MINVER} -> {0 | 1}
function check_version_app {
    prog="$1"
    ver="$2"
    sys_prog_version_wall=$($prog --version 2>/dev/null)
    if [[ $? == 127 ]]
    then
        exit 127
    fi
    sys_prog_version=$(extract_semver "$(head -n 1 <<< "$sys_prog_version_wall")")
    if [[ $(version_cmp "$ver" "$sys_prog_version") == 0 ]]
    then
        echo 0
    else
        echo 1
    fi
}

"$@"
