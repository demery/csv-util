# frozen_string_literal: true

RSpec.shared_examples 'a Util implementation' do

  context '.list_headers' do
    it 'lists the headers' do
      expect(subject.get_headers(csv_file)).to eq expected_headers
    end
  end
end