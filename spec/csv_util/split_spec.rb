# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVUtil::Split do
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

  let(:size) { 2 }
  let(:outdir) { Dir.mktmpdir }
  let(:options) { { outdir: outdir, split_size: size } }
  let(:subject) { CSVUtil::Split.new(**options) }

  context '#process' do
    it 'processes a file' do
      expect { subject.process csv_file }.not_to raise_error
    end

    it 'creates a file for every two rows' do
      expect { subject.process csv_file }.to change { Dir.entries(outdir).count }.by(3)
    end

    let(:expected_files) {
      %w[output00001.csv output00002.csv output00003.csv]
    }
    it 'creates files with the correct names' do
      subject.process csv_file
      expect(
        Dir.glob("#{outdir}/*.csv").map { |f| File.basename(f) }
      ).to match expected_files
    end

    let(:file_one_contents) {
      <<~EOF
        first_col,second_col,third_col
        easel,floor,girder
        egg,fig,grape
      EOF
    }

    let(:file_two_contents) {
      <<~EOF
        first_col,second_col,third_col
        elbow,foot,gut
        eager,fickle,giddy
      EOF
    }

    let(:file_three_contents) {
      <<~EOF
        first_col,second_col,third_col
        steak,fig,cheese
        cucumber,fig,omelet
      EOF
    }

    let(:expected_contents) {
      [
        ['output00001.csv', file_one_contents],
        ['output00002.csv', file_two_contents],
        ['output00003.csv', file_three_contents]
      ]
    }

    it 'writes the expected file contents' do
      subject.process csv_file
      expected_contents.each do |filename, contents|
        expect(File.read(File.join(outdir, filename))).to eq(contents)
      end
    end

    context 'lines not divisible by split size' do
      let(:subject) { CSVUtil::Split.new(**options.merge(split_size: 4)) }
      it 'creates the correct number of files' do
        expect { subject.process csv_file }.to change { Dir.entries(outdir).count }.by(2)
      end

      let(:expected_files) {
        %w[output00001.csv output00002.csv]
      }
      it 'creates the expected files names' do
        subject.process csv_file
        expect(
          Dir.glob("#{outdir}/*.csv").map { |f| File.basename(f) }
        ).to match expected_files
      end
    end
  end

end