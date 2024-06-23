# frozen_string_literal: true

module CSVUtil
  ## Read the CSV input and yield each row
  module CSVReader

    DEFAULT_ENCODING  = 'utf-8'
    DEFAULT_SEPARATOR = ','

    ##
    # Read the CSV input and yield each row
    #
    # @param input [IO,String,StringIO] input
    # @yield [CSV::Row]
    def read input, &block
      raise CSVUtil::Error, "Invalid encoding #{encoding}" unless valid_encoding? encoding

      options = {
        col_sep: in_col_sep,
        encoding: "#{encoding}:utf-8",
        headers: true
      }
      CSV.parse input, **options, &block
    end

    ##
    # @return [String] column separator (usually a comma)
    def in_col_sep
      @in_col_sep ||= DEFAULT_SEPARATOR
    end

    # @return [String] the input CSV encoding; defaults to 'utf-8'
    def encoding
      @encoding ||= DEFAULT_ENCODING
    end

    ##
    # Verity that the given encoding is in the ruby list of encodings.
    # @return [Boolean] whether the given +encoding+ is a known encoding#
    def valid_encoding? encoding
      Encoding.list.flat_map(&:names).include? encoding.upcase
    end
  end
end