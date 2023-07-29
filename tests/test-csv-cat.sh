#!/usr/bin/env bash

##
# Test csv-cat functions
#
# Instead of files on the file system, use bash process substituion to create
# named pipes.
#
# https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html
# https://www.linuxjournal.com/content/using-named-pipes-fifos-bash
#

test_concat_two_csvs() {
  expected='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
3,4,5,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
,jar,car,tsar'

  abc='a,b,c
5,6,7
3,4,5
1,2,3
3,4,5'

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

  actual=$(${CSV_CAT} <(echo "${abc}") <(echo "${bcd}"))

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_outfile_flag() {
  expected='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
3,4,5,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
,jar,car,tsar'

  abc='a,b,c
5,6,7
3,4,5
1,2,3
3,4,5'

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

  outfile=$(mktemp)

  ${CSV_CAT} -o ${outfile} <(echo "${abc}") <(echo "${bcd}")  >/dev/null 2>&1
  actual=$(cat ${outfile})
  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sorted() {
  expected='a,b,c,d
,bat,cat,fat
,jar,car,tsar
,jar,car,tsar
,rug,bug,tug
1,2,3,
3,4,5,
3,4,5,
5,6,7,'

  abc='a,b,c
5,6,7
3,4,5
1,2,3
3,4,5'

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

  actual=$(${CSV_CAT} --sort <(echo "${abc}") <(echo "${bcd}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pipe_two_csvs() {

  # pipe a list of csv files to csv-cat

  expected='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
3,4,5,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
,jar,car,tsar'

  # temp csv file 1
  abc=$(mktemp)
  cat <<EOF > ${abc}
a,b,c
5,6,7
3,4,5
1,2,3
3,4,5
EOF

  # temp csv file 2
  bcd=$(mktemp)
  cat <<EOF > ${bcd}
b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar
EOF

  # print the list of files to csv-cat
  actual=$(printf "${abc}\n${bcd}" | ${CSV_CAT})

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_uniq() {
expected='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug'

  abc='a,b,c
5,6,7
3,4,5
1,2,3
3,4,5'

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

  actual=$(${CSV_CAT} --uniq <(echo "${abc}") <(echo "${bcd}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sort_uniq() {
  expected='a,b,c,d
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
1,2,3,
3,4,5,
5,6,7,'

  abc='a,b,c
5,6,7
3,4,5
1,2,3
3,4,5'

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

  actual=$(${CSV_CAT} --sort --uniq <(echo "${abc}") <(echo "${bcd}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_three_csvs() {
  expected='a,b,c,d,e,f,g
5,6,7,,,,
3,4,5,,,,
1,2,3,,,,
3,4,5,,,,
,bat,cat,fat,,,
,jar,car,tsar,,,
,rug,bug,tug,,,
,jar,car,tsar,,,
,,,,egg,fig,grape
,,,,elbow,foot,gut
,,,,easel,floor,girder'

  abc="a,b,c
5,6,7
3,4,5
1,2,3
3,4,5"

  bcd='b,c,d
bat,cat,fat
jar,car,tsar
rug,bug,tug
jar,car,tsar'

efg='e,f,g
egg,fig,grape
elbow,foot,gut
easel,floor,girder'

  actual=$(${CSV_CAT} <(echo "${abc}") <(echo "${bcd}") <(echo "${efg}") )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

CSV_CAT="eval ../exe/csv-cat"
