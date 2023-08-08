#!/usr/bin/env bash

input_csv='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

test_pipe_to_csv_slice() {
  expected='first_col,second_col,third_col
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

  # print line 3 and the rest of the CSV
  actual=$( echo "${input_csv}" |  ${CSV_SLICE} --slice 3 )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_slice_from_line_number() {
  expected='first_col,second_col,third_col
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

  # print line 3 and the rest of the CSV
  actual=$(${CSV_SLICE} --slice 3 <(echo "${input_csv}")  )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_slice_number_of_lines() {
  expected='first_col,second_col,third_col
egg,fig,grape
elbow,foot,gut'

  # print line 2 and the next line
  actual=$(${CSV_SLICE} --slice 2,1 <(echo "${input_csv}")  )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_slice_line_range() {
  expected='first_col,second_col,third_col
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy'

  # print lines 2-4
  actual=$(${CSV_SLICE} --slice 2..4 <(echo "${input_csv}")  )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_find_matching_row_number_by_text() {
  expected='4'

  # find the number of the first row with 'fickle' in 'second_col'
  actual=$(${CSV_SLICE} --matching-row "second_col=fickle" <(echo "${input_csv}")  )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_find_matching_row_number_by_regex() {
  expected='2'

  # find the number of the first row where 'third_col' matches /g[^i]/
  # this should skip row 1 which has 'girder'; and match row two with 'grape'
  actual=$(${CSV_SLICE} --matching-row "third_col=g[^i]" <(echo "${input_csv}")  )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_split_input_csv() {
  expected_split_file="/tmp/$$-slice-2-3.csv"
  expected_comps_file="/tmp/$$-complements-1+4-6.csv"
  ${CSV_SLICE} --slice 2..3 --split --outfile /tmp/$$.csv <(echo "${input_csv}") >/dev/null
  assert "test -e ${expected_split_file}"
  assert "test -e ${expected_comps_file}"
}

teardown_suite() {
  rm -f $$*.csv
}

CSV_SLICE="eval ../exe/csv-slice"