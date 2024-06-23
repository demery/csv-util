require  'csv'

module CSVUtil
  # Extract the contents of a column or columns from the input csv.
  class Cut
    include CSVUtil::Util
    include CSVUtil::CSVReader

    attr_reader :columns, :out_col_sep,
                :output_headers, :list_headers

    # @param columns [Array<String>] Columns to extract
    # @param options [Hash] Options
    # @option [:in_col_sep] [String] input column separator (default: ',')
    # @option [:out_col_sep] [String] output column separator (default: ',')
    # @option [:output_headers] [Boolean] print headers in the output (default: false)
    # @option [:list_headers] [Boolean] list headers in the input and quit
    # @option [:encoding] [String] input encoding (default: 'utf-8')
    # @option [:in_col_sep] [String] input column separator (default: ',')
    # @return [CSVUtil::Cut]
    def initialize columns, options: {}
      @columns        = columns
      @out_col_sep    = options[:out_col_sep] || DEFAULT_SEPARATOR
      @output_headers = options[:output_headers]
      @list_headers   = options[:list_headers]
      @encoding       = options[:encoding] || DEFAULT_ENCODING
      @in_col_sep     = options[:in_col_sep] || DEFAULT_SEPARATOR
    end

    ##
    # Process the input CSV either by printing the headers or extracting
    # the specified columns {#columns}
    # @param [IO,String,StringIO] input
    def process input
      if list_headers
        print_headers input, col_sep: in_col_sep
        return
      end

      CSV col_sep: out_col_sep do |csv|
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
    # Validate that columns have been specified and there columns are in the input CSV
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