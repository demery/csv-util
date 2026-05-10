# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVUtil::Sample do
  let(:csv) {
    <<~CSV
      first_col,second_col,third_col
      easel,floor,girder
      egg,fig,grape
      elbow,foot,gut
      eager,fickle,giddy
      steak,fig,cheese
      cucumber,fig,omelet
    CSV
  }

  let(:csv_file) {
    sio = StringIO.new
    sio.write csv
    sio.rewind
    sio
  }

  let(:options) { {} }
  let(:subject) { CSVUtil::Sample.new csv_file, **options }

  def capture_stdout
    io = StringIO.new
    orig, $stdout = $stdout, io
    yield
    io.string
  ensure
    $stdout = orig
  end

  def data_rows(output)
    output.strip.split("\n").length - 1
  end

  context '#process' do
    it 'outputs the header row' do
      output = capture_stdout { subject.process }
      expect(output.lines.first.chomp).to eq 'first_col,second_col,third_col'
    end

    it 'outputs 1 data row by default' do
      output = capture_stdout { subject.process }
      expect(data_rows(output)).to eq 1
    end

    context 'with count: 3' do
      let(:options) { { count: 3 } }

      it 'outputs 3 data rows' do
        output = capture_stdout { subject.process }
        expect(data_rows(output)).to eq 3
      end
    end

    context 'with seed' do
      let(:options) { { seed: 42 } }

      it 'produces the same output on repeated runs' do
        sio2 = StringIO.new; sio2.write csv; sio2.rewind
        out1 = capture_stdout { subject.process }
        out2 = capture_stdout { CSVUtil::Sample.new(sio2, seed: 42).process }
        expect(out1).to eq out2
      end
    end

    context 'when count exceeds row count' do
      let(:options) { { count: 100 } }

      it 'outputs all rows' do
        output = capture_stdout { subject.process }
        expect(data_rows(output)).to eq 6
      end
    end
  end
end
