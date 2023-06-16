#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=${script_dir}/fixtures/csv-cut

export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$


test_cut_one_column() {
  expected=$(cat ${fixtures}/one_column.csv)

  actual=$(${CSV_CUT} -c second_col ${fixtures}/source.csv)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_one_column_with_headers() {
  expected=$(cat ${fixtures}/one_column_headers.csv)

  actual=$(${CSV_CUT} -c second_col --headers ${fixtures}/source.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns() {
  expected=$(cat ${fixtures}/two_columns.csv)

  actual=$(${CSV_CUT} -c first_col,third_col ${fixtures}/source.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns_with_headers() {
  expected=$(cat ${fixtures}/two_columns_headers.csv)

  actual=$(${CSV_CUT} -c first_col,third_col --headers ${fixtures}/source.csv)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_cut_two_columns_with_pipe_separator() {
  expected=$(cat ${fixtures}/two_columns_tabs.csv)

  actual=$(${CSV_CUT} -c first_col,third_col -s '\|' ${fixtures}/source.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_list_headers() {
  expected=$(cat ${fixtures}/headers.txt)

  actual=$(${CSV_CUT} --list-headers ${fixtures}/source.csv)

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
