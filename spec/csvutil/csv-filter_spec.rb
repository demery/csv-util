require 'spec_helper'

RSpec.describe 'csv-filter', :type => :aruba do

  context 'when run with --help', :type => :aruba do
    before { run_command 'csv-filter --help' }

    it { expect(last_command_started).to have_output an_output_string_matching 'Usage: csv-filter' }
  end

  context 'when filtering by --text=fig', type: :aruba do
    before { copy '%/csv-filter/unfiltered.csv', '.' }
    let(:output) { read('%/csv-filter/filtered-text.csv').join($/) }

    before { run_command 'csv-filter --column f --text=fig unfiltered.csv' }

    it { expect(last_command_started).to have_output output}
  end

  context 'when filtering by --regex', type: :aruba do
    before { copy '%/csv-filter/unfiltered.csv', '.' }
    let(:output) { read('%/csv-filter/filtered-regex.csv').join($/) }

    before { run_command 'csv-filter --column e --regex="^.*ea" unfiltered.csv' }

    it { expect(last_command_started).to have_output output}
  end
end