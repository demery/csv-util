require 'spec_helper'

RSpec.describe 'csv-cat', :type => :aruba do

  context 'when run with --help', :type => :aruba do
    before { run_command 'csv-cat --help' }

    it { expect(last_command_started).to have_output an_output_string_matching 'Usage: csv-cat' }
  end

  context 'when concatting two csvs' do
    # copy fixture files
    before { copy '%/csv-cat/abc.csv', '.'}
    before { copy '%/csv-cat/bcd.csv', '.'}
    let(:output) { read('%/csv-cat/abcbcd.csv').join($/) }
    before { run_command 'csv-cat abc.csv bcd.csv' }

    it { expect(last_command_started).to have_output output }
  end

  context 'when concatting two csvs with --uniq' do
    # copy fixture files
    before { copy '%/csv-cat/abc.csv', '.'}
    before { copy '%/csv-cat/bcd.csv', '.'}
    let(:output) { read('%/csv-cat/abcbcd-uniq.csv').join($/) }
    before { run_command 'csv-cat --uniq abc.csv bcd.csv' }

    it { expect(last_command_started).to have_output output }
  end

  context 'when concatting two csvs with --sort' do
    # copy fixture files
    before { copy '%/csv-cat/abc.csv', '.'}
    before { copy '%/csv-cat/bcd.csv', '.'}
    let(:output) { read('%/csv-cat/abcbcd-sort.csv').join($/) }
    before { run_command 'csv-cat --sort abc.csv bcd.csv' }

    it { expect(last_command_started).to have_output output }
  end

  context 'when concatting two csvs with --sort --uniq' do
    # copy fixture files
    before { copy '%/csv-cat/abc.csv', '.'}
    before { copy '%/csv-cat/bcd.csv', '.'}
    let(:output) { read('%/csv-cat/abcbcd-sort-uniq.csv').join($/) }
    before { run_command 'csv-cat --sort --uniq abc.csv bcd.csv' }

    it { expect(last_command_started).to have_output output }
  end

  context 'when concatting three csvs' do
    # copy fixture files
    before { copy '%/csv-cat/abc.csv', '.'}
    before { copy '%/csv-cat/bcd.csv', '.'}
    before { copy '%/csv-cat/efg.csv', '.'}
    let(:output) { read('%/csv-cat/abcbcdefg.csv').join($/) }
    before { run_command 'csv-cat abc.csv bcd.csv efg.csv' }

    it { expect(last_command_started).to have_output output }
  end
end