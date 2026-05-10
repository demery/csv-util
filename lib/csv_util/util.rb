# frozen_string_literal: true

module CSVUtil
  module Util

    ##
    # Print the headers in the input to stdout.
    # @param input [IO,String,StringIO] CSVReader stream
    # @param col_sep [String] Column separator
    # @return [void]
    def print_headers input, col_sep: ','
      puts 'Headers in input:'
      puts '---'
      puts get_headers input, col_sep: col_sep
    end

    ##
    # @param input [IO,String,StringIO] CSVReader stream
    # @param col_sep [String] Column separator
    # @return [Array<String>] Array of headers
    def get_headers input, col_sep: ','
      if input.respond_to? :gets
        line = input.gets
        return [] unless line
        CSV.parse_line(line, col_sep: col_sep) || []
      else
        File.open(input) { |f| get_headers(f, col_sep: col_sep) }
      end
    end
  end
end