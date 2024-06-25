# frozen_string_literal: true

require 'spec_helper'

class TestWriter
  include CSVUtil::CSVWriter

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
      expect {
        TestWriter.new.process rows
      }.to output(expected).to_stdout
    end
  end


end