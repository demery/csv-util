# frozen_string_literal: true

module CSVUtil
  # Utitlty methods for writing CSVs.
  #
  # Including classes should have the following instance variables:
  #
  # +@outfile+:: the output file name, if outputting to a file; overrides +@output+
  # +@output+:: the output stream (if +@outfile+ is not set); defaults to $stdout
  # +@encoding+:: the output CSV encoding; defaults to 'utf-8'
  # +@out_col_sep+:: the output column separator; defaults to ','
  module CSVWriter

    def write &block

      options = {
        col_sep: out_col_sep,
        encoding: encoding.to_s,
        headers: true
      }

      CSV output, **options, &block
    end

    # @return [String] column separator (usually a comma)
    def out_col_sep
      @out_col_sep ||= CSVUtil::DEFAULT_SEPARATOR
    end

    # @return [String] the input CSV encoding; defaults to 'utf-8'
    def encoding
      @encoding ||= CSVUtil::DEFAULT_ENCODING
    end

    def output
      return @output if @output

      if @outfile
        @output = File.open @outfile, 'w'
      else
        @output = $stdout
      end
    end

  end
end