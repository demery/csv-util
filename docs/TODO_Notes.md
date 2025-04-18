# CSV Utils scripts

## Cut: csv-cut

Cut columns from a CSV based on column headers, outputting a
new CSV. 

TODO: Add -f, --fields option to allow numeric field selection
TODO: Add -H, --no-headers option to treat CSV as if it has no headers

## Cat: csv-cat

Concatenate two or more CSVs returning a new CSV with a Union of the columns from the input CSVs.

Functions:
- cat
- uniq
- sort
- reverse

TODO: Remove uniq and sort functions.
TODO: Add -H, --no-headers option to treat CSV as if it has no headers
TODO: Add -r, --reverse option

## Filter: csv-filter

Accept an input CSV, a column name and  string or regex to matching that 
column, returning only matching rows

Functions:

- select by filter
- reject by filter

QUESTION: Add a -f, --fields option to allow numeric field selection?
TODO: Add -H, --no-headers option to treat CSV as if it has no headers; requires -f
TODO: Add -w, --row option to match on any column in a row; incompatible with -f and -c

## Slice: csv-slice

Accept an input CSV, print new CSVs based on a numeric slice specification;
e.g., `3..5` to print rows 3-5.

Functions:
- Print complements CSV of those rows not in the slice

TODO: Renamae '-r', '--regex' to '-p', '--pattern' 
TODO: Add '-r', '--pattern-range' to specify a from to range based on 
a regular expression
TODO: Add -H, --no-headers option to treat CSV as if it has no headers

## Split: csv-split

Like the Unix `split` command, split a CSV into multiple CSVs

TODO: Add -H, --no-headers option to treat CSV as if it has no headers
TODO: Add -r, --pattern to split on a regex pattern (e.g., 'foo')
TODO: Add -b, --bytes to split on byte count (e.g., 1000)

## Sort: csv-sort (TODO)

Accept an input CSV and print a sorted CSV of the input.

Options:
- -u, --uniq: print unique rows only
- -r, --reverse: reverse sort order

## Paste: csv-paste (TODO)

Join the corresponding rows of two or more CSVs

Options:

- (?) -m, --merge: when rows share columns concatenate their contents

## Merge: csv-merge (TODO)

Join two CSVs based on a key column. Like `csv-paste` but only joins 
rows with matching key values ignoring others
