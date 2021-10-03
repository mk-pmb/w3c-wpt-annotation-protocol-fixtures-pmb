#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function upd_all () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH"/.. || return $?

  local CACHE_DIR="download-cache/$(date +%y%m%d)"
  mkdir --parents -- "$CACHE_DIR" || return $?

  local REPO_NAME='web-platform-tests/wpt'
  local REPO_URL="https://github.com/$REPO_NAME"
  local DL_BASEURL="$REPO_URL/raw/master/"
  local LICENSE_FN='LICENSE.md'
  local SUBDIR='annotation-protocol/files/annotations'
  local DIRLIST_BFN='_files_list'

  echo -n "D: Verify license: "
  dl_one "/$LICENSE_FN" || return $?
  cmp -- {,"$CACHE_DIR"/}"$LICENSE_FN" || return $?
  echo 'as expected.'

  dl_entire_subdir || return $?
  copy_compile_anno_files || return $?
}


function dl_entire_subdir () {
  dl_one . || return $?
  scan_github_dirlist "$CACHE_DIR/$DIRLIST_BFN" || return $?
  local LIST=()
  readarray -t LIST <"$CACHE_DIR/$DIRLIST_BFN".txt || return $?

  local ITEM=
  local ERR_CNT=0 SXS_CNT=0
  for ITEM in "${LIST[@]}"; do
    if dl_one "$ITEM"; then (( SXS_CNT += 1 )); else (( ERR_CNT+=1 )); fi
  done

  [ "$ERR_CNT" == 0 ] || return 8$(
    echo "E: $ERR_CNT files failed to download." >&2)
  echo "I: $SXS_CNT files downloaded or cached."
}


function dl_one () {
  local SRC="$1"
  local URL=
  local DEST="${SRC#/}"
  case "$SRC" in
    . )
      DEST="$DIRLIST_BFN.html"
      URL+="$SUBDIR"
      SRC=;;
    /* ) SRC="$DEST";;
    * ) URL+="$SUBDIR/";;
  esac
  URL+="$SRC"
  ( dl_one_inner ) || return $?
}


function dl_one_inner () {
  cd -- "$CACHE_DIR" || return $?
  local DL_TMP="tmp.$$.$DEST.part"
  if [ -s "$DEST" ]; then
    # echo "cached."
    return 0
  fi
  echo -n "D: download: $DEST <- tree:$URL : "
  [ ! -e "$DL_TMP" ] || rm -- "$DL_TMP" || return $?
  wget --output-document="$DL_TMP" -- "$DL_BASEURL$URL" || return $?
  mv --verbose --no-target-directory -- "$DL_TMP" "$DEST" || return $?
}


function scan_github_dirlist () {
  local BFN="$1"
  local QUOT='"' APOS="'"
  grep -oPe '<a [^<>]*>' -- "$BFN".html \
    | grep -oPe ' href="/[^"]+' \
    | grep -Fe " href=$QUOT/$REPO_NAME/blob/" \
    | grep -oPe '[^/]+$' \
    >"$BFN".txt
  [ -s "$BFN".txt ] || return 4$(echo "E: $FUNCNAME: found no files!" >&2)
}


function copy_compile_anno_files () {
  local EX_DIR='examples'
  mkdir --parents -- "$EX_DIR" || return $?
  rm -- "$EX_DIR"/*.json 2>/dev/null

  cp --target-directory="$EX_DIR" -- "$CACHE_DIR"/*.json || return $?
  rename --filename -e '
    s!\-?(\d+\.)!- °00000000$1!g;
    s! °0*(\d{3})\b!$1!g;
    s! °0*!!g;
    ' -- "$EX_DIR"/*.json || return $?

  grep -hPe . -- "$EX_DIR"/anno-[0-9]*.json | sed -rf <(echo '
    s~^\}$~&,~
    1s~^~[0,\n~
    $s~,?$~]~
    ') >"$EX_DIR"/anno-all.json || return $?

  eslint -- "$EX_DIR"/*.json || return $?
}












upd_all "$@"; exit $?
