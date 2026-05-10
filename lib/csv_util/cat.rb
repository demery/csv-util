# frozen_string_literal: true

module CSVUtil
  # Concatenate two or more CSVs returning a new CSV with a Union of
  # the columns from the input CSVs.
  class Cat < Command

    attr_reader :files

    # See {CSVUtil::Command#initialize} for options
    #
    # @param files [Array<String>] CSV files
    def initialize *files, **options
      @files = files
      super options
    end

    # Return an array of CSV file paths or yield the CSV path if a
    # block is given.
    #
    # @return [Array<String>] CSV file paths
    # @yield [String] CSV file path
    def csvs
      files.each do |f|
        csv = if File::ftype(f) == 'fifo'
                tf = Tempfile.new
                tf.puts File.open(f).read
                tf.close
                tf.path
              else
                f
              end
        yield csv if block_given?
        csv
      end
    end

    # Return an array of headers from the input CSVs
    # @param [Array<String>] csv headeers
    def header
      csvs.flat_map { |csv| CSV.readlines(csv).first }.uniq
    end

    # Concatenate the input CSVs, writing the result to +output+ or,
    # if provided, to +outfile+.
    #
    # If +list_headers+ is true, print the headers and return.
    def process
      if list_headers
        csvs.each do |csv|
          print_headers csv, col_sep: options[:in_col_sep]
        end
        return
      end

      first_row = true
      write do |csv|
        csvs do |input|
          read input do |row|
            if first_row
              csv << header
              first_row = false
            end
            csv << row.to_h
          end
        end
      end
    end

  end
end
