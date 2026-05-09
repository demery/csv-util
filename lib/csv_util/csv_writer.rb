# frozen_string_literal: true
# encoding: utf-8

module CSVUtil
  # Utility methods for writing CSVs.
  #
  # Including classes should have the following instance variables:
  #
  # +@outfile+:: the output file name, if outputting to a file; overrides +@output+
  # +@output+:: the output stream (if +@outfile+ is not set); defaults to $stdout
  # +@output_encoding+:: the output CSV encoding; defaults to 'utf-8'
  # +@out_col_sep+:: the output column separator; defaults to ','
  module CSVWriter

    def write &block
      options = {
        col_sep: out_col_sep,
        headers: true
      }

      if file_output?
        CSV.open output, 'w', **options, &block
      else
        CSV output, **options, &block
      end
    end

    # @return [String] column separator (usually a comma)
    def out_col_sep
      @out_col_sep ||= CSVUtil::DEFAULT_SEPARATOR
    end

    def file_output?
      @outfile.present?
    end

    def output
      # return @output if @output

      @output ||= @outfile ? File.open(@outfile, 'w') : $stdout
    end

  end
end