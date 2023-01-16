require 'spec_helper'

RSpec.describe 'csv-pluck', :type => :aruba do

  context 'when run with --help', :type => :aruba do
    before { run_command 'csv-pluck --help' }

    it { expect(last_command_started).to have_output an_output_string_matching 'Usage: csv-pluck' }
  end

  context 'when plucking one column', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) { read('%/csv-pluck/one_column.csv').join($/) }

    before { run_command 'csv-pluck source.csv second_col' }

    it { expect(last_command_started).to have_output output}
  end

  context 'when plucking one column with --headers', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) { read('%/csv-pluck/one_column_headers.csv').join($/) }

    before { run_command 'csv-pluck --headers source.csv second_col' }

    it { expect(last_command_started).to have_output output}
  end

  context 'when plucking two columns', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) { read('%/csv-pluck/two_columns.csv').join($/) }

    before { run_command 'csv-pluck source.csv first_col third_col' }

    it { expect(last_command_started).to have_output output}
  end

  context 'when plucking two columns with --headers', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) { read('%/csv-pluck/two_columns_headers.csv').join($/) }

    before { run_command 'csv-pluck --headers source.csv first_col third_col' }

    it { expect(last_command_started).to have_output output}
  end

  context 'when plucking two columns --separator="\t"', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) { read('%/csv-pluck/two_columns_tabs.csv').join($/) }

    before { run_command %q{csv-pluck --separator='	' source.csv first_col third_col} }

    it { expect(last_command_started).to have_output output}
  end

  context 'when listing headers', type: :aruba do
    before { copy '%/csv-pluck/source.csv', '.' }
    let(:output) {  "Headers in source.csv:\n---\nfirst_col\nsecond_col\nthird_col" }

    before { run_command %q{csv-pluck --list-headers source.csv} }

    it { expect(last_command_started).to have_output output}
  end


end