# frozen_string_literal: true

require 'spec_helper'

class TestWriter
  include CSVUtil::CSVWriter

  attr_reader :output_encoding

  def initialize **options
    @output_encoding = options[:output_encoding]
    @outfile = options[:outfile]
  end

  def process rows
    write do |csv|
      rows.each_with_index { |row,ndx|
        csv << row.keys if ndx == 0
        csv << row
      }
    end
  end
end

RSpec.describe CSVUtil::CSVWriter do
  let (:subject) { TestWriter.new }
  let(:rows) {
    [
      { a: 1, b: 2, c: 3 },
      { a: 4, b: 5, c: 6 }
    ]
  }

  let(:expected) {
    <<~EOF
      a,b,c
      1,2,3
      4,5,6
    EOF
  }

  context '#write' do
    it 'writes a CSV' do
      expect { subject.process rows }.to output(expected).to_stdout
    end

    context 'when the output encoding is not UTF-8' do
      let(:subject) { TestWriter.new output_encoding: output_ending, outfile: outfile }
      let(:output_ending) { 'UTF-16LE' }
      let(:outfile) { Tempfile.new('test') }

      let(:rows) {
        CSV.open(fixture_dir(path: 'utf-8.csv'), headers: true).map(&:to_h)
      }

      it 'writes a CSV' do
        subject.process rows
        expect(outfile).to exist
      end

      let(:expected) { IO.readlines fixture_dir(path: 'utf-16.csv') }
      it 'has the expected output' do
        subject.process rows
        expect(IO.readlines(outfile.path)).to eq expected
      end
    end
  end

end