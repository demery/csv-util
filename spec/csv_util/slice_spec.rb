# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVUtil::Slice do

  let(:csv) {
    <<~EOF
      first_col,second_col,third_col
      easel,floor,girder
      egg,FIG,grape
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

  let(:subject) { CSVUtil::Slice.new }

  context '.new' do
    it 'creates a CSVUtil::Slice instance' do
      expect(CSVUtil::Slice.new).to be_a(CSVUtil::Slice)
    end
  end

  context '.range' do
    let(:slice_spec) { '3..5' }
    let(:subject) { CSVUtil::Slice.new(slice_spec: slice_spec) }
    it 'returns a Range' do
      expect(subject.range).to be_a(Range)
    end

    context 'with a single row number -- n' do
      let(:slice_spec) { '3' }
      let(:expected) { (3..) }
      it 'returns an endless range' do
        expect(subject.range).to eq(expected)
      end
    end

    context 'with a row number and count -- n,m' do
      let(:slice_spec) { '3,2' }
      let(:expected) { (3..5) }
      it 'returns a range' do
        expect(subject.range).to eq(expected)
      end
    end

    context 'with a range string -- n..m' do
      let(:slice_spec) { '3..5' }
      let(:expected) { (3..5) }
      it 'returns a range' do
        expect(subject.range).to eq(expected)
      end
    end

    context 'with a range string -- n..' do
      let(:slice_spec) { '3..' }
      let(:expected) { (3..) }
      it 'returns an endless range' do
        expect(subject.range).to eq(expected)
      end
    end

    context 'when no slice spec is provided' do
      let(:slice_spec) { nil }
      let(:expected) { nil }
      it 'returns nil' do
        expect(subject.range).to eq(expected)
      end
    end

    context 'when the slice spec is invalid' do
      let(:slice_spec) { 'a' }
      it 'raises an error' do
        expect { subject.range }.to raise_error(ArgumentError)
      end
    end
  end
end