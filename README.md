# CSV Util


A small set of ruby utilities for working with CSV files packaged as a gem with executables and a library of functions.

## Functions

- `csv-filter`- accept an input CSV, a column name and  string or regex to matching that column, returning only matching rows
- `csv-pluck`- accept an input CSV and a list of columns, returning a new CSV with only the selected columns
- `csv-cat` - concatenate two or more CSVs returning a new CSV with a Union of the columns from the input CSVs
  -  Potential optional behavior: return a CSV of the intersection of the input CSVs' columns

### Maybe also

- `cvs-merge` - join two CSVs based on a key column
  - question: when there are other shared columns, do you prefer one CVS's column values, do you represent all columns
  - Question: what about non-matching rows? Are they discarded or added to the end?

## Features of all scripts

- Accept input CSV from piped STDIN
  - **Exception**: `csv-cat` can accept only a list of  CSVs
- Output result CSV to STDOUT
  - Potential optional behavior: allow specification of output file name

## Todo

- [ ] Create a separate repo as a gem using bundler
- [ ] Move existing scripts to the new repo
- [ ] Use ruby 3.x?
- [ ] Use Thor?
- [ ] Remove current ARGF behavior that expects a list of files
- [ ] Remove current output file specification?
- [ ] Create `lib/csv-util`
  - [ ] Add CLI base
  - [ ] Add shared function for determining input type: list of CSVs or piped CSV data
- [ ] Add README with description, project plan



