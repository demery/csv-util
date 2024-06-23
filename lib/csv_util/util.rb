# frozen_string_literal: true

module CSVUtil
  module Util

    ##
    # Print the headers in the input to stdout.
    # @param input [IO,String,StringIO] Input stream
    # @param col_sep [String] Column separator
    # @return [void]
    def print_headers input, col_sep: ','
      puts 'Headers in input:'
      puts '---'
      puts get_headers input, col_sep: col_sep
    end

    ##
    # @param input [IO,String,StringIO] Input stream
    # @param col_sep [String] Column separator
    # @return [Array<String>] Array of headers
    def get_headers input, col_sep: ','
      csv_data = CSV.parse(input, col_sep: col_sep)
      return [] if csv_data.blank?

      csv_data.first || []
    end
  end
end