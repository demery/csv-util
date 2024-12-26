# frozen_string_literal: true

module CSVUtil
  ## Read the CSV input and yield each row
  #
  # Including classes should have the following instance variables:
  #
  # +@encoding+:: the input CSV encoding; defaults to 'utf-8'
  # +@in_col_sep+:: the input column separator; defaults to ','
  module CSVReader

    ##
    # Read the CSV input and yield each row
    #
    # @param input [IO,String,StringIO] input
    # @yield [CSV::Row]
    def read input, &block

      csv = csv_from input
      csv.each &block
      csv.close
    end

    # Detrmine the type of input and return a CSV object;
    #
    # IF +input+ is a string and a file exists with the same name,
    # then a CSV object will be created from the file; otherwise,
    # the string is parsed as a CSV.
    #
    # @param input [IO,String,StringIO] input an IO object, a CSV string,
    #   a file path, or a StringIO object
    # @return [CSV]
    def csv_from input, **options
      opts = {
        col_sep: in_col_sep,
        encoding: "#{encoding}:utf-8",
        headers: true
      }.merge options

      if input.is_a? StringIO
        CSV.new input, **opts
      elsif input.kind_of? IO
        CSV.new input, **opts
      elsif input.kind_of? String
        # figure out if the input is a file path or CSV string
        csv_from_string input, **opts
      elsif input.any? || $stdin.tty?
        # assume the input is an argument from the command line and
        # treat it as a file path
        csv_file = input.shift

        abort "Please provide a CSV file" unless csv_file
        abort "Can't find CSV file" unless File.exist? csv_file
        CSV.open csv_file, **opts
      else
        # read from stdin
        CSV.new $stdin, **opts
      end
    end

    # If +input+ is a string, determine if it is a file path. If so,
    # return a CSV object from the file; otherwise, assume the input
    # is a CSV string and return a CSV object.
    def csv_from_string input, **options
      return unless input.kind_of? String
      return CSV.open input, **options if File.exist? input

      CSV.new input, **options
    end

    ##
    # @return [String] column separator (usually a comma)
    def in_col_sep
      @in_col_sep ||= CSVUtil::DEFAULT_SEPARATOR
    end

    # @return [String] the input CSV encoding; defaults to 'utf-8'
    def encoding
      @encoding ||= CSVUtil::DEFAULT_ENCODING
    end

    ##
    # Verity that the given encoding is in the ruby list of encodings.
    # @return [Boolean] whether the given +encoding+ is a known encoding#
    def valid_encoding? encoding
      Encoding.list.flat_map(&:names).include? encoding.upcase
    end
  end
end
