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
  let(:subject) { CSVUtil::Cut.new csv_file, columns }

  context 'implementations' do
    let(:expected_headers) { %w[first_col second_col third_col] }

    it_behaves_like 'a Util implementation'

    let(:expected) {
      <<~EOF
      easel,floor
      egg,fig
      elbow,foot
      eager,fickle
      steak,fig
      cucumber,fig
      EOF
    }

    it_behaves_like 'a command implementation'
  end


  context '.new' do
    it 'creates a CSVUtil::Cut instance' do
      expect(described_class.new csv_file, columns).to be_a CSVUtil::Cut
    end
  end

  context '#process' do
    it 'processes a file' do
      suppress_output do
        expect {
          subject.process
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
        subject.process
      }.to output(expected_output).to_stdout
    end

    it 'does not print headers' do
      expect {
        subject.process
      }.not_to output(/first_col/).to_stdout
    end

    it 'prints headers if requested' do
      options = { output_headers: true }
      cut = CSVUtil::Cut.new csv_file, columns, options: options
      expect {
        cut.process
      }.to output(/first_col/).to_stdout
    end

    context 'with out_col_sep' do
      let(:subject) {
        CSVUtil::Cut.new csv_file, columns, options: { out_col_sep: "\t" }
      }
      it 'uses the correct output separator' do
        expect {
          subject.process
        }.to output(/easel\tfloor/).to_stdout
      end
    end

    context 'with in_col_sep' do
      let(:csv) {
        <<~EOF
          first_col\tsecond_col\tthird_col
          easel\tfloor\tgirder
          egg\tfig\tgrape
          elbow\tfoot\tgut
          eager\tfickle\tgiddy
          steak\tfig\tcheese
          cucumber\tfig\tomelet
        EOF
      }

      let(:csv_file) {
        sio = StringIO.new
        sio.write csv
        sio.rewind
        sio
      }
      let(:subject) {
        CSVUtil::Cut.new csv_file, columns, options: { in_col_sep: "\t", columns: %w[first_col second_col] }
      }
      it 'uses the correct input separator' do
        expect {
          subject.process
        }.to output(/easel,floor/).to_stdout
      end
    end
  end
end