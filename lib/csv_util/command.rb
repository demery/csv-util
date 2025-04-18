# frozen_string_literal: true

require 'csv'

module CSVUtil
  class Command
    include CSVUtil::Util
    include CSVUtil::CSVReader
    include CSVUtil::CSVWriter

    attr_reader :out_col_sep
    attr_reader :in_col_sep
    attr_reader :input_encoding
    attr_reader :output_encoding
    attr_reader :list_headers
    attr_reader :outfile

    # @param options [Hash]
    # @option options [String] :out_col_sep (',') the outputcolumn separator
    # @option options [String] :in_col_sep (',') the input column separator
    # @option options [String] :input_encoding ('utf-8') the input encoding
    # @option options [String] :output_encoding ('utf-8') the output encoding
    # @option options [Boolean] :list_headers (nil) whether to list headers and quit
    # @option options [IO] :output (nil) the output stream; defaults to STDOUT
    # @option options [String] :outfile (nil) the output file path; overrides @output
    def initialize options
      @out_col_sep     = options[:out_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @in_col_sep      = options[:in_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @input_encoding  = options[:input_encoding] || CSVUtil::DEFAULT_ENCODING
      @output_encoding = options[:output_encoding] || CSVUtil::DEFAULT_ENCODING
      @list_headers    = options[:list_headers] # whether to list headers and quit
      @outfile         = options[:outfile]
      # outfile overrides @output
      @output       = @outfile.present? ? nil : options[:output]
    end

    # Process the input
    def process
      raise NotImplementedError
    end
  end
end
