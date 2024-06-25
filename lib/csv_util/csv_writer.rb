# frozen_string_literal: true

module CSVUtil
  module CSVWriter
    def write &block

      options = {
        col_sep: out_col_sep,
        encoding: "#{encoding}",
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
      @output ||= $stdout
    end

  end
end