#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=fixtures/csv-filter


export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$

unfiltered='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

test_filter_by_text() {
  expected='first_col,second_col,third_col
egg,fig,grape
steak,fig,cheese
cucumber,fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text fig <(echo "${unfiltered}")  )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_regex() {
  expected='first_col,second_col,third_col
easel,floor,girder
eager,fickle,giddy
steak,fig,cheese'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*ea" ${fixtures}/unfiltered.csv  )

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

CSV_FILTER="eval ../exe/csv-filter"
