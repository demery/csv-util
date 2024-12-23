# frozen_string_literal: true

module CSVUtil
  class Slice
    include CSVUtil::Util
    include CSVUtil::CSVReader
    include CSVUtil::CSVWriter

    attr_reader :slice_spec, :row_query, :random_count, :split

    # Initialize the slice object
    #
    # +:row_query+, +:slice_spec+, and +:random_count+ are mutually exclusive.
    #
    # +:row_query+ is used to return the number of the row that matches the patter
    # for a given column.
    #
    # +:slice_spec+ specifies which rows to return in the output CSVs; the known
    # slice spec formats are:
    #
    # - +n+: write a CSV of all row numbers at +n+; e.g., '3': return a new CSV
    #       of all rows in the source CSV starting at row 3
    # - +start_row,count+: write a CSV of +count+ rows starting at +start_row+;
    #     e.g., '3,10': return a new CSV of 10 rows starting at row 3 in the
    #     source CSV
    #
    # - +start_row..end_row+: write a CSV of rows starting at +start_row+ and
    #   ending at +end_row+; e.g., '3..5': return a new CSV of 3 rows starting
    #   at row 3 and ending at row 5
    #
    # - +split+: return two CSVs: one of the sliced rows and one of the remainder
    #
    # @param options [Hash] the options
    # @option options [String] :in_col_sep (',') the column separator
    # @option options [String] :out_col_sep (',') the output column separator
    # @option options [String] :encoding ('utf-8') the input encoding
    # @option options [String] :slice_spec (nil) the slice spec for row number(s) to slice on; e.g., '50', '50,10', '50..60'
    # @option options [String] :row_query (nil) the row query, COLUMN_NAME=PATTERN query
    # @option options [Integer] :random_count (nil) the number of random rows to return
    # @option options [Boolean] :split (nil) whether to split on the slice spec
    def initialize  options = {}
      @in_col_sep   = options[:in_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @out_col_sep  = options[:out_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @encoding     = options[:encoding] || CSVUtil::DEFAULT_ENCODING
      @slice_spec   = options[:slice_spec]
      @row_query    = options[:row_query]
      @random_count = options[:random_count]
      @split        = options[:split]
    end

    # Return the range for the slice if the slice spec is provided
    # @return [Range]
    def range
      return unless slice_spec
      return @range if @range.present?

      case slice_spec
      when /\A\d+\z/
        @range = (Integer(slice_spec)..)
      when /\A\d+,\d+\z/
        start, count = slice_spec.split(',').map { |i| Integer i }
        @range = (start..start + count)
      when /\A\d+\.{2}\d+\z/
        start, stop = slice_spec.split('..').map { |i| Integer i }
        @range = (start..stop)
      when /\A\d+\.\.\z/
        @range = eval slice_spec
      else
        raise ArgumentError,"Invalid slice specification: '#{slice_spec}'"
      end
    end

    def in_slice? index
      range.include? index
    end

    def handle_input input

    end

    # Process the input and print the output to stdout
    # @param input [IO,String,StringIO] input
    # @return [nil]
    def process input
      index = 0
      write do |csv|
        read input do |row|
          csv << row.heads if index.zero?
          csv << row if in_slice? index
          index += 1
        end
      end
    end
  end
end