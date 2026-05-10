#!/usr/bin/env bash

input_csv='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'

test_sample_default_is_one_row() {
  actual=$(echo "${input_csv}" | ${CSV_SAMPLE})
  rows=$(echo "${actual}" | wc -l)
  assert_equals 2 ${rows} 'Unexpected number of rows (header + 1 data row)'
}

test_sample_count() {
  actual=$(echo "${input_csv}" | ${CSV_SAMPLE} --count 3)
  rows=$(echo "${actual}" | wc -l)
  assert_equals 4 ${rows} 'Unexpected number of rows (header + 3 data rows)'
}

test_sample_includes_header() {
  actual=$(echo "${input_csv}" | ${CSV_SAMPLE} --count 2)
  header=$(echo "${actual}" | head -1)
  assert_equals 'first_col,second_col,third_col' "${header}" 'Missing or wrong header'
}

test_sample_seed_is_reproducible() {
  out1=$(echo "${input_csv}" | ${CSV_SAMPLE} --count 2 --seed 42)
  out2=$(echo "${input_csv}" | ${CSV_SAMPLE} --count 2 --seed 42)
  assert_equals "${out1}" "${out2}" 'Seeded runs produced different output'
}

test_pipe_to_csv_sample() {
  actual=$(echo "${input_csv}" | ${CSV_SAMPLE} --count 2)
  rows=$(echo "${actual}" | wc -l)
  assert_equals 3 ${rows} 'Unexpected number of rows'
}

CSV_SAMPLE="eval ../exe/csv-sample"
