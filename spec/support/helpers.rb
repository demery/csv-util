# frozen_string_literal: true

require 'tempfile'

module Helpers
  def fixture_dir path: nil
    fix_dir = File.expand_path File.join __dir__, '../fixtures'
    return fix_dir unless path.present?
    File.join fix_dir, path
  end

  def temp_file content, name: ''
    if block_given?
      Tempfile.new name do |temp_file|
        temp_file.puts content
        temp_file.rewind
        yield temp_file
      end
    else
      tf = Tempfile.new name
      tf.puts content
      tf.rewind
      tf
    end
  end

  def suppress_output
    original_stderr = $stderr.clone
    original_stdout = $stdout.clone
    $stderr.reopen(File.new('/dev/null', 'w'))
    $stdout.reopen(File.new('/dev/null', 'w'))
    yield
  ensure
    $stdout.reopen(original_stdout)
    $stderr.reopen(original_stderr)
  end
end
