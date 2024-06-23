# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe CSVUtil::Cut do


  let(:csv) {
    <<~EOF
      first_col,second_col,third_col
      easel,floor,girder
      egg,fig,grape
      elbow,foot,gut
      eager,fickle,giddy
      steak,fig,cheese
      cucumber,fig,omelet
    EOF
  }

  let(:csv_file) {
    sio = StringIO.new
    sio.write csv
    sio.rewind
    sio
  }

  let(:columns) { %w[first_col second_col] }
  let(:subject) { CSVUtil::Cut.new columns }

  describe '.new' do
    it 'creates a CSVUtil::Cut instance' do
      expect(described_class.new columns).to be_a CSVUtil::Cut
    end
  end

  context '#process' do
    it 'processes a file' do
      suppress_output do
        expect {
          subject.process csv_file.read
        }.not_to raise_error
      end
    end

    let(:expected_output) {
      <<~EOF
        easel,floor
        egg,fig
        elbow,foot
        eager,fickle
        steak,fig
        cucumber,fig
      EOF
    }

    it 'has the expected output' do
      expect {
        subject.process csv_file.read
      }.to output(expected_output).to_stdout
    end
  end
end
