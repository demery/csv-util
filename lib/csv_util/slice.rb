# frozen_string_literal: true

module CSVUtil
  class Slice < Command

    attr_reader :input

    attr_reader :slice_spec
    attr_reader :row_query
    attr_reader :random
    attr_reader :split
    attr_reader :outfile

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
    # See {CSVUtil::Command#initialize} for options
    #
    # @param input [IO,String,StringIO] CSVReader stream
    # @param options [Hash] the options
    # @option options [String] :slice_spec (nil) the slice spec for row number(s) to slice on; e.g., '50', '50,10', '50..60'
    # @option options [String] :row_query (nil) the row query, COLUMN_NAME=PATTERN query
    # @option options [Integer] :random_count (nil) the number of random rows to return
    # @option options [Boolean] :split (nil) whether to split on the slice spec
    def initialize input, options = {}
      @input        = input
      @slice_spec   = options[:slice_spec]
      @row_query    = options[:row_query]
      @random       = options[:random]
      @split        = options[:split]
      @outfile      = options[:outfile]

      super options
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

    def find_matching_row
      raise "Invalid row number query #{row_query}" unless row_query =~ %r{\A[^=]+="?.+\z}
      header, pattern = row_query.split '=', 2
      row_num = 0
      found = false
      CSV.parse input, headers: true do |row|
        raise "Unknown header: #{header}" unless row[header]
        row_num += 1
        if row[header] =~ %r{#{pattern}}
          found = true
          break
        end
      end

      if found
        puts row_num
        exit 0
      else
        $stderr.puts "WARNING: No row found matching #{options[:row_query]}"
        exit 1
      end
    end

    # Output the slice CSV and second CSV of the rows not in the slice
    def process_with_splits
      slice_tmp = Tempfile.new
      comp_tmp = Tempfile.new
      csv_slice = CSV.open slice_tmp, 'w', headers: true
      csv_comp  = CSV.open comp_tmp, 'w', headers: true
      skips = [] # array to hold the list of all skipped row numbers
      CSV.parse(input, headers: true).each_with_index do |row, index|
        csv_slice << row.headers if index == 0
        csv_comp  << row.headers if index == 0
        row_num = index + 1

        # pick the CSV to write to; slice or complement
        if in_slice? row_num
          csv = csv_slice
        else
          csv = csv_comp
          skips << row_num
        end
        csv << row.to_h
      end
      skips_string = build_skips_string skips
      comps_path = build_file_name(outfile, type: 'complements', span_string: skips_string)
      FileUtils.mv csv_comp.path, comps_path

      slice_string = [range.first, range.last].uniq.join '-'
      slice_path = build_file_name(outfile, type: 'slice', span_string: slice_string)
      FileUtils.mv csv_slice.path, slice_path

      slice_tmp.close
      comp_tmp.close
    end

    def process_random
      data = CSV.parse input, headers: true
      rows = Set.new
      selections = (1...data.size).to_a.sample random

      CSV output, headers: true do |csv|
        data.each_with_index do |row, index|
          csv << row.headers if index == 0
          csv << row.to_h if selections.include? index
        end
      end
    end

    # Process the input and print the output to stdout
    # @param input [IO,String,StringIO] input
    # @return [nil]
    def process
      return find_matching_row if row_query
      return process_with_splits if split
      return process_random if random

      index = 0
      write do |csv|
        read input do |row|
          csv << row.headers if index.zero?
          csv << row if in_slice? index + 1
          index += 1
        end
      end
    end

    def build_file_name outfile, type:, span_string:
      ext       = File.extname outfile
      base_path = outfile.chomp ext

      "#{base_path}-#{type}-#{span_string}#{ext}"
    end

    # For an array of integers for each row skipped by the slice operation,
    # output the complement string for a sliced CSV.
    #
    # A sliced CSV has in its name the slice spec for the range of rows sliced from a
    # source CSV; e.g., for a slice spc of +3..5+, the span string is +3-5+.
    # The complement string is the span string for all the rows that
    # <b>aren't</b> in the sliced CSV; for example, for a source CSV of 10
    # rows with a slice spec of +3..5+, the 'complements' CSV would have
    # rows 1-2 and 6-10 of the source CSV and the span string would be
    #
    #   1-2+6-10
    #
    # @example
    #   build_skips_string([1,2,6,7,8,9,10])  # => 1-2+6-10
    #
    # So, in use:
    #
    # @example Given a file +source.csv+ with ten rows:
    #   $ csv-slice --split --spec 3..5 --outfile output.csv source.csv
    #   Wrote: output-slice-3-5.csv, output-complement-1-2+6-10
    #
    # @param [Array<Integer>] skipped_rows an array integers of all skipped
    #   row numbers; e.g., [1, 2, 6, 7, 8, 9, 10]: rows 1 to 2 and 6 to 10
    #   were skipped
    # @return [String] the complement string for the provided pairs; e.g.,
    #   +1-2\+6-10+; rows 1 to 2 and 6 to 10 were skipped
    def build_skips_string skipped_rows
      # scan the input array and create range pairs for sequential skips;
      # for example, in the following:
      #
      #   [1, 2, 5, 7, 8, 9, 10]
      #
      # 1-2, 5, and 7-10 are sequences of skipped rows; convert the source
      # array to an array of pairs of integers representing the continuous
      # blocks of skipped rows:
      #
      #  [1, 2, 5, 5, 7, 10] # 1-2, 5-5, and 7-10
      #
      # This can be turned into an array of arrays of pairs that can then
      # be mapped into a 'skips string':
      #
      #   [1, 2, 5, 5, 7, 10].each_slice(2).map { |pair|
      #     pair.uniq.join '-'
      #   }.join '+' # => 1-2+5+7-10
      #
      #   ....
      skipped_rows.reduce([]) { |ra, i|
        # turn
        if ra.empty?
          ra << i << i # e.g., [1, 1]
        elsif ra.last.succ == i
          ra[-1] = i   # e.g., [1, 1][-1] = 2 # => [1, 2]
        else
          ra << i << i # e.g., [1, 2] << 5 << 5 # = [1, 2, 5, 5 ]
        end
        ra
      }.each_slice(2).map { |pair|
        # now we have [1,2,5,5,7,10];
        # split that array into two-integer pairs: [[1,2], [5,5], [7,10]];
        # then join the uniq values each pair with '-'; thus:
        # ['1-2', '5', '7-10']
        pair.uniq.join '-'
      }.join '+' # => '1-2+5+7-10'
    end
  end
end