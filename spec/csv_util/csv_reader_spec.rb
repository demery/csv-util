# frozen_string_literal: true

require 'spec_helper'

class ReaderTest
  attr_reader :input_encoding
  def initialize **options
    @input_encoding = options[:input_encoding]
  end

  include CSVUtil::CSVReader
end

RSpec.describe CSVUtil::CSVReader do

  let(:csv) {
    <<~EOF
      first_col,second_col,third_col
      easel,floor,girder
      egg,fig,grape
    EOF
  }

  let(:csv_file) {
    sio = StringIO.new
    sio.write csv
    sio.rewind
    sio
  }

  let(:subject) { ReaderTest.new }

  context '#read' do
    context 'when the input is a StringIO' do
      it 'reads a CSV' do
        expect { |b|
          subject.read csv_file, &b
        }.not_to raise_error
      end
    end

    it 'yields a CSV::Row' do
      expect { |b|
        subject.read csv_file, &b
      }.to yield_successive_args CSV::Row, CSV::Row
    end

  end

  context '#csv_from' do
    context 'when the input file is UTF-16' do
      let(:subject) { ReaderTest.new input_encoding: 'UTF-16' }
      let(:csv_file_path) { fixture_dir path: 'utf-16.csv'  }
      let(:result) { subject.csv_from csv_file_path }
      let(:expected) { CSV.open fixture_dir(path: 'utf-8.csv'), headers: true }

      it 'returns a CSV object' do
        expect(result).to be_a(CSV)
      end

      it 'has the correct encoding' do
        expect(result.encoding).to eq Encoding::UTF_8
      end

      it 'has the expected content' do
        expect(result.read).to eq expected.read
      end
    end

  end
end