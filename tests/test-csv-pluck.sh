#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=fixtures/csv-pluck

export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$


test_pluck_one_column() {
  expected=$(cat ${fixtures}/one_column.csv)

  actual=$(csv-pluck ${fixtures}/source.csv second_col)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pluck_one_column_with_headers() {
  expected=$(cat ${fixtures}/one_column_headers.csv)

  actual=$(csv-pluck --headers ${fixtures}/source.csv second_col)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pluck_two_columns() {
  expected=$(cat ${fixtures}/two_columns.csv)

  actual=$(csv-pluck ${fixtures}/source.csv first_col third_col)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pluck_two_columns_with_headers() {
  expected=$(cat ${fixtures}/two_columns_headers.csv)

  actual=$(csv-pluck --headers ${fixtures}/source.csv first_col third_col)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pluck_two_columns_with_tab_separator() {
  expected=$(cat ${fixtures}/two_columns_tabs.csv)

  actual=$(csv-pluck --separator='	' ${fixtures}/source.csv first_col third_col)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_list_headers() {
  expected=$(cat ${fixtures}/headers.csv)

  actual=$(csv-pluck --list-headers ${fixtures}/source.csv)

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

# test_concat_two_csvs_sorted() {
#   expected=$(cat ${fixtures}/abcbcd-sort.csv)

#   actual=$(csv-cat --sort ${fixtures}/abc.csv ${fixtures}/bcd.csv )

#   assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
# }

# test_concat_two_csvs_uniq() {
#   expected=$(cat ${fixtures}/abcbcd-uniq.csv)

#   actual=$(csv-cat --uniq ${fixtures}/abc.csv ${fixtures}/bcd.csv )

#   assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
# }

# test_concat_two_csvs_sort_uniq() {
#   expected=$(cat ${fixtures}/abcbcd-sort-uniq.csv)

#   actual=$(csv-cat --sort --uniq ${fixtures}/abc.csv ${fixtures}/bcd.csv )

#   assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
# }

# test_concat_three_csvs() {
#   expected=$(cat ${fixtures}/abcbcdefg.csv)

#   actual=$(csv-cat ${fixtures}/abc.csv ${fixtures}/bcd.csv ${fixtures}/efg.csv )

#   assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
# }

# test_pipe_two_csvs() {
#   expected=$(cat ${fixtures}/abcbcd.csv)

#   actual=$(ls ${fixtures}/abc.csv ${fixtures}/bcd.csv | csv-cat)

#   assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
# }

# test_outfile_flag() {
#   outfile=${tmpdir}/abcbcd.csv
#   csv-cat -o $outfile ${fixtures}/abc.csv ${fixtures}/bcd.csv >/dev/null 2>&1
#   assert "test -e ${outfile}"
# }


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