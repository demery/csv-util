# frozen_string_literal: true

module CSVUtil::Util
  ##
  # @param input [IO] Input stream
  # @param options [Hash] Options
  # @option [:in_col_sep] [String] Column separator
  # @return [Array<String>] Array of headers
  def list_headers input, options: {}
    col_sep = options[:in_col_sep] || ','
    csv_data = CSV.parse(input.read, col_sep: col_sep)
    return [] if csv_data.blank?

    csv_data.first || []
  end
end
