#!/usr/bin/env bash

unfiltered='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,fig,omelet'


#####################################################################
# Filtering by text
#####################################################################
test_filter_by_text() {
  expected='first_col,second_col,third_col
egg,fig,grape
steak,fig,cheese
cucumber,fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text fig <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_text_reject() {
  expected='first_col,second_col,third_col
easel,floor,girder
elbow,foot,gut
eager,fickle,giddy'

  actual=$(${CSV_FILTER} --column second_col --text fig --reject <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_case_insensitive_text() {
  assert false
}

test_filter_reject_by_case_insensitive_text() {
  assert false
}

test_filter_by_empty_string_text() {
  assert false
}

test_filte_reject_by_empty_string_text() {
  assert false
}

test_filter_by_text_when_column_value_is_empty_string() {
  assert false
}

test_filter_reject_by_text_when_column_value_is_empty_string() {
  assert false
}


#####################################################################
# Filtering by regular expression
#####################################################################
test_filter_by_regex() {
  expected='first_col,second_col,third_col
easel,floor,girder
eager,fickle,giddy
steak,fig,cheese'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*ea" <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_regex_reject() {
  expected='first_col,second_col,third_col
egg,fig,grape
elbow,foot,gut
cucumber,fig,omelet'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*ea" --reject <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_case_insensitive_regex() {
  assert false
}

test_filter_reject_by_case_insensitive_regex() {
  assert false
}

test_filter_by_empty_regex() {
  assert false
}

test_filter_reject_by_empty_regex() {
  assert false
}

test_filter_by_regex_when_column_value_is_empty_string() {
  assert false
}

test_filter_reject_by_regex_when_column_value_is_empty_string() {
  assert false
}


#####################################################################
# Test piping to csv-filter
#####################################################################
test_pipe_to_csv_filter() {
    expected='first_col,second_col,third_col
easel,floor,girder
eager,fickle,giddy
steak,fig,cheese'

  actual=$(echo "${unfiltered}" | ${CSV_FILTER} --column first_col --regex="^.*ea")

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

CSV_FILTER="eval ../exe/csv-filter"
