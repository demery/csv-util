# frozen_string_literal: true

require 'spec_helper'

class TestUtil
  include CSVUtil::Util
end

RSpec.describe CSVUtil::Util do

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

  let(:subject) { TestUtil.new }

  context '.list_headers' do

    let(:expected) { %w[first_col second_col third_col] }
    it 'lists the headers' do
      expect(subject.list_headers(csv_file)).to eq expected
    end
  end
end
