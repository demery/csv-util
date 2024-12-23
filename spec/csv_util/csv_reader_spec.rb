# frozen_string_literal: true

require 'spec_helper'

class ReaderTest
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
end