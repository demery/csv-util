# frozen_string_literal: true

RSpec.shared_examples 'a command implementation' do |skips|

  context '#process' do
    it 'runs without error' do
      suppress_output do
        expect { subject.process }.not_to raise_error
      end
    end

    it 'has the expected output', unless: (skips || []).include?(:output) do
      expect { subject.process }.to output(expected).to_stdout
    end
  end
end