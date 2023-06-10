#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fixtures=${script_dir}/fixtures/csv-cat


export PATH=${script_dir}/../exe:$PATH

tmpdir=${TMPDIR:-/tmp}/$$

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

efg='e,f,g
egg,fig,grape
elbow,foot,gut
easel,floor,girder'

abcbcd_concat='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
3,4,5,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
,jar,car,tsar'

abcbcd_sort='a,b,c,d
,bat,cat,fat
,jar,car,tsar
,jar,car,tsar
,rug,bug,tug
1,2,3,
3,4,5,
3,4,5,
5,6,7,'

abcbcd_uniq='a,b,c,d
5,6,7,
3,4,5,
1,2,3,
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug'

abcbcd_sort_uniq='a,b,c,d
,bat,cat,fat
,jar,car,tsar
,rug,bug,tug
1,2,3,
3,4,5,
5,6,7,'

abcbcdefg_concat='a,b,c,d,e,f,g
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

outfile=$(mktemp)

setup() {
  abc_csv=$(mktemp)
  echo "${abc}" > ${abc_csv}

  bcd_csv=$(mktemp)
  echo "${bcd}" > ${bcd_csv}

  efg_csv=$(mktemp)
  echo "${efg}" > ${efg_csv}
}

test_concat_two_csvs() {
  expected="${abcbcd_concat}"
  actual=$(csv-cat ${abc_csv} ${bcd_csv} )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sorted() {
  expected="${abcbcd_sort}"
  actual=$(csv-cat --sort ${abc_csv} ${bcd_csv} )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_uniq() {
  expected="${abcbcd_uniq}"
  actual=$(csv-cat --uniq ${abc_csv} ${bcd_csv} )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_two_csvs_sort_uniq() {
  expected="${abcbcd_sort_uniq}"
  actual=$(csv-cat --sort --uniq ${abc_csv} ${bcd_csv} )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_concat_three_csvs() {
  expected="${abcbcdefg_concat}"
  actual=$(csv-cat ${abc_csv} ${bcd_csv} ${efg_csv} )

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_pipe_two_csvs() {
  expected="${abcbcd_concat}"
  file_list=$(mktemp)
  printf "${abc_csv}\n${bcd_csv}" > ${file_list}

  actual=$(csv-cat < ${file_list})

  assert_equals "${expected}" "${actual}" 'Unexpected CSV output'
}

test_outfile_flag() {
  expected="${abcbcd_concat}"
  outfile=${tmpdir}/abcbcd-csv$$

  csv-cat -o ${outfile} ${abc_csv}  ${bcd_csv}  >/dev/null 2>&1
  actual=$(cat ${outfile})
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
