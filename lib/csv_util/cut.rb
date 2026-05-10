
module CSVUtil
  # Extract the contents of a column or columns from the input csv.
  class Cut < Command

    attr_reader :columns
    attr_reader :input
    attr_reader :output_headers

    # See {CSVUtil::Command#initialize} for options
    #
    # @param input [IO,String,StringIO] CSVReader stream
    # @param columns [Array<String>] Columns to extract
    # @param options [Hash] Options
    # @option [:output_headers] [Boolean] print headers in the output (default: false)
    # @return [CSVUtil::Cut]
    def initialize input, columns, options: {}
      @input          = input
      @columns        = columns
      @output_headers = options[:output_headers]
      super options
    end

    ##
    # Process the input CSV either by printing the headers or extracting
    # the specified columns +columns+ and writing them to the output
    # @param [IO,String,StringIO] input
    def process
      if list_headers
        print_headers input, col_sep: in_col_sep
        return
      end

      write do |csv|
        first_row = true
        read input do |row|
          if first_row
            handle_first_row row, csv
            first_row = false
          end
          csv << columns.map { |column| row[column] }
        end
      end
    end

    ##
    # Validate that columns have been specified and the columns are in the input CSV
    #
    # @param row [CSV::Row] First row of the CSV
    # @return [void]
    # @raise [CSVUtil::Error] if no columns have been specified
    # @raise [CSVUtil::Error] if the columns are not in the CSV
    def validate_columns row
      raise CSVUtil::Error, 'No cut columns specified' if columns.blank?

      row_hash = row.to_h
      missing = columns - row_hash.keys
      return if missing.blank?

      raise CSVUtil::Error, "Expected columns (#{missing.join ', '}) not in CSV: #{row_hash.keys.join ', '}"
    end

    ##
    # Validate the first row and add the headers if requested
    def handle_first_row row, csv
      validate_columns row
      csv << columns if output_headers
    end
  end
end