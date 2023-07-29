#!/usr/bin/env bash

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

  actual=$(${CSV_FILTER} --column second_col --text fig <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_filter_by_regex() {
  expected='first_col,second_col,third_col
easel,floor,girder
eager,fickle,giddy
steak,fig,cheese'

  actual=$(${CSV_FILTER} --column first_col --regex="^.*ea" <(echo "${unfiltered}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

CSV_FILTER="eval ../exe/csv-filter"
