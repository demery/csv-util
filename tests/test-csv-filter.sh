#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=fixtures/csv-filter


export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$


test_filter_by_text() {
  expected=$(cat ${fixtures}/filtered-text.csv)

  actual=$(csv-filter --column second_col --text fig ${fixtures}/unfiltered.csv  )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_regex() {
  expected=$(cat ${fixtures}/filtered-regex.csv)

  actual=$(csv-filter --column first_col --regex="^.*ea" ${fixtures}/unfiltered.csv  )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

setup_suite() {
  mkdir ${tmpdir}
}

teardown_suite() {
  rm_opts=-rf
  if [[ -n ${CSVUTIL_VERBOSE} ]]
  then
    rm_opts="${rm_opts} -v"
  fi
  rm ${rm_opts} ${tmpdir}
}