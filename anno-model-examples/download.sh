#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dl_main () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local MODEL_DEST='model.html'
  dl_model || return $?
  rm_old_examples || return $?
  <"$MODEL_DEST" LANG=C sed -rf <(echo '
    : read_all
    $!{N;b read_all}
    s~[\r\a\f]~~g
    s~\n~\f~g
    s~<div class="example-title marker">~\n\a~g
    s~</pre>~\n~g
    ') | sed -rf <(echo '
    /^\a/!d
    s~</?(span|div)\b[^<>]*>~~g
    s~^\aExample ~0000~
    s~^0*([0-9]{3}):~ex\1~
    s~\f\s*<pre [^<>]+>~\f~
    s~\f~\n:~g
    s~$~\n.~
    ') | write_files || return $?
}


function rm_old_examples () {
  local EX= BFN=
  for EX in ex{000..999}_*.json; do
    [ -e "$EX" ] || continue
    BFN="${EX%.json}"
    [ "${BFN//[^a-z0-9_]/}" == "$BFN" ] || continue
    rm -- "$EX" || return $?
  done
}


function dl_model () {
  [ -s "$MODEL_DEST" ] && return 0
  wget --output-document="tmp.$MODEL_DEST.part" --continue \
    -- https://www.w3.org/TR/annotation-model/ || return $?
  mv --no-clobber --no-target-directory --verbose \
    -- "tmp.$MODEL_DEST.part" "$MODEL_DEST" || return $?
}


function write_files () {
  local LN=
  while IFS= read -r LN; do case "$LN" in
    ex* )
      LN="${LN,,}"
      LN="${LN//[^a-z0-9]/_}"
      exec >"$LN.json" || return $?
      ;;
    :* ) echo "${LN:1}";;
    . ) exec >&2;;
    * ) echo "E: unsupported input line: $LN" >&2; return 8;;
  esac; done
}








dl_main "$@"; exit $?
