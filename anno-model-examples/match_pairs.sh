#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function matcher () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  filesums_sorted | cut -sf 2- | LANG=C sort || return $?
}


function filesums_sorted () {
  filesums_all | sort | uniq --check-chars=32 --group=both | sed -rf <(echo '
    : read_group
    /\n$/!{N;b read_group}
    s~^\s+~~
    s~\n\S+ ~\t~g
    s~\s+$~~
    /\t/!s~$~\t?~
    s~ ~\t~g
    ')
}


function filesums_all () {
  local FN=
  for FN in ex ../examples/anno-; do
    for FN in "$FN"[0-9]*.json; do
      filesum_one "$FN" || return $?
    done
  done
}


function filesum_one () {
  local FN="$1"
  local HASH="$(filesum_one__filter "$FN" | tr -d ' \r\n' | md5sum --text)"
  HASH="${HASH%%[ *]*}"
  echo "$HASH $FN"
}


function filesum_one__filter () {
  local FN="$1"
  sed -rf <(echo '
    \|^  "id": "http://example.org/|d
    s~\r~~g
    $a
    ') -- "$@" | sed -rf <(echo '
    ${/^$/d}
    ') || return $?
}










matcher "$@"; exit $?
