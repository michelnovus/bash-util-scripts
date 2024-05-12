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

"$@"
