#!/usr/bin/env bash

unfiltered='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,foot,gut
eager,fickle,giddy
steak,fig,cheese
cucumber,Fig,omelet'

unfiltered_with_empty_string='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
elbow,,gut
eager,fickle,giddy
steak,,cheese
cucumber,Fig,omelet'


#####################################################################
# Filtering by text
#####################################################################
test_filter_by_text() {
  expected='first_col,second_col,third_col
egg,fig,grape
steak,fig,cheese'

  actual=$(${CSV_FILTER} --column second_col --text fig <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_text_reject() {
  expected='first_col,second_col,third_col
easel,floor,girder
elbow,foot,gut
eager,fickle,giddy
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text fig --reject <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_case_insensitive_text() {
  expected='first_col,second_col,third_col
egg,fig,grape
steak,fig,cheese
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text FIG --case-insensitive <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_reject_by_case_insensitive_text() {
  expected='first_col,second_col,third_col
easel,floor,girder
elbow,foot,gut
eager,fickle,giddy'

  actual=$(${CSV_FILTER} --column second_col --text fig --case-insensitive --reject <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_empty_string_text() {
    expected='first_col,second_col,third_col
elbow,,gut
steak,,cheese'

  actual=$(${CSV_FILTER} --column second_col --text \'\' <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filte_reject_by_empty_string_text() {
  expected='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
eager,fickle,giddy
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text \'\' --reject <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_text_when_column_value_is_empty_string() {
  expected='first_col,second_col,third_col
egg,fig,grape'

  actual=$(${CSV_FILTER} --column second_col --text fig <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_reject_by_text_when_column_value_is_empty_string() {
  expected='first_col,second_col,third_col
easel,floor,girder
elbow,,gut
eager,fickle,giddy
steak,,cheese
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --text fig --reject <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
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
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*ea" --reject <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_case_insensitive_regex() {
  expected='first_col,second_col,third_col
easel,floor,girder
eager,fickle,giddy
steak,fig,cheese'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*EA" --case-insensitive <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_reject_by_case_insensitive_regex() {
  expected='first_col,second_col,third_col
egg,fig,grape
elbow,foot,gut
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*eA" --reject --case-insensitive <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_empty_regex() {
  expected='first_col,second_col,third_col
elbow,,gut
steak,,cheese'

  actual=$(${CSV_FILTER} --column second_col --regex="^$" <(echo "${unfiltered_with_empty_string}") )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_reject_by_empty_regex() {
  expected='first_col,second_col,third_col
easel,floor,girder
egg,fig,grape
eager,fickle,giddy
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --regex="^$" --reject <(echo "${unfiltered_with_empty_string}") )
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_regex_when_column_value_is_empty_string() {
    expected='first_col,second_col,third_col
egg,fig,grape
eager,fickle,giddy'

  actual=$(${CSV_FILTER} --column second_col --regex="^fi" <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_reject_by_regex_when_column_value_is_empty_string() {
  expected='first_col,second_col,third_col
easel,floor,girder
elbow,,gut
steak,,cheese
cucumber,Fig,omelet'

  actual=$(${CSV_FILTER} --column second_col --regex="^fi" --reject <(echo "${unfiltered_with_empty_string}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
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
