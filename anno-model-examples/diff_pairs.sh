#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function diff_pairs () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?
  ./download.sh || return $?
  local PAIRS=()
  readarray -t PAIRS < <(./match_pairs.sh)
  local EX= ANNO= BFN= RV=
  for EX in "${PAIRS[@]}"; do
    ANNO="${EX##*$'\t'}"
    EX="${EX%%$'\t'*}"
    BFN="$(basename -- "$EX" .json)"
    BFN="d${BFN#ex}"
    [ "$ANNO" == '?' ] && ANNO=/dev/null
    diff --report-identical-files --unified=9009009 \
      --label "$ANNO" <(norm_final_eol "$ANNO") \
      -- "$EX" >"$BFN".diff
    RV="$?"
    rm -- "$BFN".same 2>/dev/null
    if [ "$RV" == 0 ]; then
      mv --no-target-directory -- "$BFN".{diff,same}
    fi
  done
}


function norm_final_eol () {
  ( cat -- "$@" ; echo ) | sed -re '${/^$/d}'
}










diff_pairs "$@"; exit $?
