#!/usr/bin/env bash

# Requires BashUnit2

set -o errexit
set -o nounset
set -o pipefail

if which bash_unit >/dev/null; then
  :
else
  echo "Missing dependency: bashunit2"
  echo "Please make sure it is installed and in your PATH"
  exit 1
fi

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "${this_dir}" || exit 1


for test in test-*.sh; do
  bash_unit "${test}"
done