# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVUtil::Filter do

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

  let(:column) { 'second_col' }

  let(:subject) { described_class.new column }

  context '.new' do
    it 'creates a CSVUtil::Filter instance' do
      expect(described_class.new column).to be_a CSVUtil::Filter
    end
  end

  context '.filter' do
    context 'text matching' do
      context 'with text given' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          { text: 'fig' }
        }
        let(:subject) { described_class.new column, **options }
        it 'outputs rows with a given string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            egg,FIG,grape
            elbow,foot,gut
            eager,fickle,giddy
          EOF
        }

        let(:options) {
          {
            text:            'fig',
            reject_matching: true
          }
        }

        let(:subject) { described_class.new column, **options }

        it 'outputs rows not containing the text' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given and insensitive: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            egg,FIG,grape
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            text:        'fig',
            insensitive: true
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that match regardless of case' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end

      end
      context 'with text given, insensitive: true, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            elbow,foot,gut
            eager,fickle,giddy
          EOF
        }

        let(:options) {
          {
            text:            'fig',
            reject_matching: true,
            insensitive:     true
          }
        }

        let(:subject) { described_class.new 'second_col', **options }

        it 'outputs rows not containing the text' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given and insensitive: false' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            egg,FIG,grape
          EOF
        }

        let(:options) {
          {
            text:        'FIG',
            insensitive: false,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that only match the given string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given, insensitive: false, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            elbow,foot,gut
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            text:            'FIG',
            insensitive:     false,
            reject_matching: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that do not match the given string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end
    end

    context 'regex matching' do
      context 'with regex given' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            pattern: 'fi.*',
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that match a regex' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with regex given and reject: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            egg,FIG,grape
            elbow,foot,gut
          EOF
        }

        let(:options) {
          {
            pattern:         'fi.*',
            reject_matching: true
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that do not match a regex' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with regex given and insensitive: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            egg,FIG,grape
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            pattern:     'fi.*',
            insensitive: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that match a given string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with regex given, insensitive: true, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            elbow,foot,gut
          EOF
        }

        let(:options) {
          {
            pattern:         'fi.*',
            insensitive:     true,
            reject_matching: true
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that do not match the regular expression' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with regex given and insensitive: false' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            egg,FIG,grape
          EOF
        }

        let(:options) {
          {
            pattern:     'FI.*',
            insensitive: false,
          }
        }

        let(:subject) { described_class.new column, pattern: 'FI.*', insensitive: false }

        it 'outputs rows that match a given string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with regex given, insensitive: false, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            elbow,foot,gut
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            pattern:         'FI.*',
            insensitive:     false,
            reject_matching: true,
          }
        }

        let(:subject) { described_class.new column, **options }

        it 'outputs rows that do not match the regular expression' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end
    end

    context 'substring matching' do
      context 'with text given and substring: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            text:      'fi',
            substring: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that contain a string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given, substring: true, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            egg,FIG,grape
            elbow,foot,gut
          EOF
        }

        let(:options) {
          {
            text:            'fi',
            substring:       true,
            reject_matching: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that do not contain the string' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given, substring: true and insensitive: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            egg,FIG,grape
            eager,fickle,giddy
            steak,fig,cheese
            cucumber,fig,omelet
          EOF
        }

        let(:options) {
          {
            text:        'fi',
            substring:   true,
            insensitive: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that contain the substring' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end

      context 'with text given, substring: true, insensitive: true, and reject_matching: true' do
        let(:expected) {
          <<~EOF
            first_col,second_col,third_col
            easel,floor,girder
            elbow,foot,gut
          EOF
        }

        let(:options) {
          {
            text:            'fi',
            substring:       true,
            insensitive:     true,
            reject_matching: true,
          }
        }

        let(:subject) { described_class.new column, **options }
        it 'outputs rows that do not contain the substring' do
          expect { subject.filter csv_file }.to output(expected).to_stdout
        end
      end
    end
  end

end