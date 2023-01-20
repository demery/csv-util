#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=${script_dir}/fixtures/csv-cat


export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$


test_concat_two_csvs() {
  expected=$(cat ${fixtures}/abcbcd.csv)

  actual=$(csv-cat ${fixtures}/abc.csv ${fixtures}/bcd.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sorted() {
  expected=$(cat ${fixtures}/abcbcd-sort.csv)

  actual=$(csv-cat --sort ${fixtures}/abc.csv ${fixtures}/bcd.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_uniq() {
  expected=$(cat ${fixtures}/abcbcd-uniq.csv)

  actual=$(csv-cat --uniq ${fixtures}/abc.csv ${fixtures}/bcd.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sort_uniq() {
  expected=$(cat ${fixtures}/abcbcd-sort-uniq.csv)

  actual=$(csv-cat --sort --uniq ${fixtures}/abc.csv ${fixtures}/bcd.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_three_csvs() {
  expected=$(cat ${fixtures}/abcbcdefg.csv)

  actual=$(csv-cat ${fixtures}/abc.csv ${fixtures}/bcd.csv ${fixtures}/efg.csv )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pipe_two_csvs() {
  expected=$(cat ${fixtures}/abcbcd.csv)

  actual=$(ls ${fixtures}/abc.csv ${fixtures}/bcd.csv | csv-cat)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_outfile_flag() {
  outfile=${tmpdir}/abcbcd.csv
  csv-cat -o $outfile ${fixtures}/abc.csv ${fixtures}/bcd.csv >/dev/null 2>&1
  assert "test -e ${outfile}"
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