#!/usr/bin/env bash

input_csv='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

test_pipe_to_csv_split() {
  expected="output00001.csv
output00002.csv
output00003.csv"
  # print line 3 and the rest of the CSV
  echo "${input_csv}" |  ${CSV_SPLIT} --size 2 --output-dir ${TEMP_DIR} --prefix 'output' >/dev/null
  actual=$(cd ${TEMP_DIR} && ls *.csv)
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_input_csv() {
    expected="output00001.csv
output00002.csv
output00003.csv"
    ${CSV_SPLIT} --size 2 --output-dir ${TEMP_DIR} --prefix 'output' <(echo "${input_csv}") >/dev/null
      actual=$(cd ${TEMP_DIR} && ls *.csv)
      assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_output_file_content() {
  ${CSV_SPLIT} --size 2 --output-dir ${TEMP_DIR} --prefix 'output' <(echo "${input_csv}") >/dev/null

  expected_001="first_col,second_col,third_col
easel,floor,girder
egg,fig,grape"
  actual_001=$(cd ${TEMP_DIR} && cat output00001.csv)
  assert_equals "${expected_001}" "${actual_001}" 'Unexpected CSV output'

  expected_002="first_col,second_col,third_col
elbow,foot,gut
eager,fickle,giddy"
  actual_002=$(cd ${TEMP_DIR} && cat output00002.csv)
  assert_equals "${expected_002}" "${actual_002}" 'Unexpected CSV output'

  expected_003="first_col,second_col,third_col
steak,fig,cheese
cucumber,fig,omelet"
  actual_003=$(cd ${TEMP_DIR} && cat output00003.csv)
  assert_equals "${expected_003}" "${actual_003}" 'Unexpected CSV output'
}

test_alternate_prefix() {
  ${CSV_SPLIT} --size 2 --output-dir ${TEMP_DIR} --prefix 'alt-prefix' <(echo "${input_csv}") >/dev/null
  expected="alt-prefix00001.csv
alt-prefix00002.csv
alt-prefix00003.csv"
  actual=$(cd ${TEMP_DIR} && ls *.csv)
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_alternate_width() {
  ${CSV_SPLIT} --size 2 --output-dir ${TEMP_DIR} --prefix 'alt-prefix' --width 3 <(echo "${input_csv}") >/dev/null
  expected="alt-prefix001.csv
alt-prefix002.csv
alt-prefix003.csv"
  actual=$(cd ${TEMP_DIR} && ls *.csv)
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

teardown() {
  rm -f ${TEMP_DIR}/*.csv
}

teardown_suite() {
  rm -f $$*.csv
}

CSV_SPLIT="eval ../exe/csv-split"
TEMP_DIR="$(mktemp -d)"