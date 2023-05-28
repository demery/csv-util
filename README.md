# CSV Util

A small set of ruby utilities for working with CSV files packaged as a gem with executables and a library of functions.

## Functions

- `csv-filter`- accept an input CSV, a column name and  string or regex to matching that column, returning only matching rows
- `csv-cut`- accept an input CSV and a list of columns, returning a new CSV with only the selected columns
- `csv-cat` - concatenate two or more CSVs returning a new CSV with a Union of the columns from the input CSVs
  -  Potential optional behavior: return a CSV of the intersection of the input CSVs' columns
- `csv-slice` - accept an input CSV and slice specification and output a new CSV of the specified rows

### Maybe also

- `cvs-merge` - join two CSVs based on a key column
  - Question: when there are other shared columns, do you prefer one CVS's column values?, do you represent all columns?
  - Question: what about non-matching rows? Are they discarded or added to the end?
- `csv-paste` - csv version of `paste` command, filling blank column values in joined files
  - Question: If the `paste` command does all these things, is this worth doing?
    - Not everyone knows `paste`.
    - This completes the functions of the suite.
    - If these functions are turned into a library, an in-library `paste` function could be useful.


#### An excursus on `paste` vs the proposed `csv-paste`

Note that `paste` does not fill blank columns with commas (`,`s) to maintain column header correspondence in its output.

Given `abc.csv`:

```csv
a,b,c
5,6,7
3,4,5
1,2,3
3,4,5
```

And `efg.csv`:

```csv
e,f,g
egg,fig,grape
elbow,foot,gut
easel,floor,girder
```

The desired result of `csv-paste efg.csv abc.csv` would be:

```csv
e,f,g,a,b,c
egg,fig,grape,5,6,7
elbow,foot,gut,3,4,5
easel,floor,girder,1,2,3
,,,3,4,5
```

Thus maintaining the column-value alignemnt in the last row: `{ e: '', f, '', g: '', a: 3, b: 4, c: 5 }`. The `paste` command does not do this:

```csv
$ paste -d, efg.csv abc.csv
e,f,g,a,b,c
egg,fig,grape,5,6,7
elbow,foot,gut,3,4,5
easel,floor,girder,1,2,3
,3,4,5
```

Thus yielding the wrong column-value correspondences: `{ e: '', f: 3, g: 4, a: 5, b: '', c: '' }`

## Features of all scripts

- Accept input CSV from piped STDIN
  - **Exception**: `csv-cat` can accept only a list of  CSVs
- Output result CSV to STDOUT
  - Potential optional behavior: allow specification of output file name
