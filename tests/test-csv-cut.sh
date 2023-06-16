#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=${script_dir}/fixtures/csv-cut

export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$

source_csv='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

test_cut_one_column() {
  expected='floor
fig
foot
fickle
fig
fig'

  actual=$(${CSV_CUT} -c second_col  <(echo "${source_csv}"))
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_one_column_with_headers() {
  expected='second_col
floor
fig
foot
fickle
fig
fig'

  actual=$(${CSV_CUT} -c second_col --headers <(echo "${source_csv}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns() {
  expected='easel,girder
egg,grape
elbow,gut
eager,giddy
steak,cheese
cucumber,omelet'

  actual=$(${CSV_CUT} -c first_col,third_col  <(echo "${source_csv}"))

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns_with_headers() {
  expected='first_col,third_col
easel,girder
egg,grape
elbow,gut
eager,giddy
steak,cheese
cucumber,omelet'

  actual=$(${CSV_CUT} -c first_col,third_col --headers <(echo "${source_csv}"))

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns_with_pipe_separator() {
  expected='easel|girder
egg|grape
elbow|gut
eager|giddy
steak|cheese
cucumber|omelet'

  actual=$(${CSV_CUT} -c first_col,third_col -s '\|' <(echo "${source_csv}"))

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_list_headers() {
  expected='Headers in input:
---
first_col
second_col
third_col'

  actual=$(${CSV_CUT} --list-headers <(echo "${source_csv}"))

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

CSV_CUT="eval ../exe/csv-cut"
