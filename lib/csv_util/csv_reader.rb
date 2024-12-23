# frozen_string_literal: true

module CSVUtil
  ## Read the CSV input and yield each row
  module CSVReader

    ##
    # Read the CSV input and yield each row
    #
    # @param input [IO,String,StringIO] input
    # @yield [CSV::Row]
    def read input, &block
      raise CSVUtil::Error, "Invalid encoding #{encoding}" unless valid_encoding? encoding

      # options = {
      #   col_sep: in_col_sep,
      #   encoding: "#{encoding}:utf-8",
      #   headers: true
      # }
      csv = csv_from input

      csv.each &block
      csv.close
      # CSV.parse input, **options, &block
    end

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
        CSV.new input, **opts
      elsif input.any? || $stdin.tty?
        csv_file = input.shift

        abort "Please provide a CSV file" unless csv_file
        abort "Can't find CSV file" unless File.exist? csv_file
        CSV.new csv_file, **opts
      else
        CSV.new $stdin, **opts
      end
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
