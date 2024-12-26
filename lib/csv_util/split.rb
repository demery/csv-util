# frozen_string_literal: true

require 'fileutils'
require 'tempfile'

module CSVUtil
  # Split the input CSV into multiple files
  class Split < Command


    attr_reader :input
    
    attr_reader :split_size
    attr_reader :prefix
    attr_reader :outdir
    attr_reader :width

    DEFAULT_INDEX_WIDTH = 5
    DEFAULT_SPLIT_SIZE = 100
    DEFAULT_PREFIX     = 'output'
    DEFAULT_OUTDIR     = '.'


    # @param options [Hash] Options
    # @option [:split_size] [Integer] number of rows per file (default: 100)
    # @option [:encoding] [String] input encoding (default: 'utf-8')
    # @option [:prefix] [String] output filename prefix (default: 'output')
    # @option [:out_dir] [String] output directory (default: '.')
    # @option [:width] [Integer] width of index, left-padded with zeros in output file names (default: 5)
    def initialize input, options={}
      @input      = input
      @split_size = options[:split_size] || DEFAULT_SPLIT_SIZE
      @prefix     = options[:prefix] || DEFAULT_PREFIX
      @outdir     = options[:outdir] || DEFAULT_OUTDIR
      @width      = options[:width] || DEFAULT_INDEX_WIDTH

      super options
    end

    def build_file_name count
      index = (count % split_size).zero? ? count / split_size : count / split_size + 1
      base = format "#{prefix}%0#{width}d.csv", index
      File.join outdir, base
    end

    def output_csv_options
      { encoding: encoding, headers: true }
    end

    def process
      count = 0
      csv = nil
      tmp_csv = nil
      read input do |row|
        if (count % split_size).zero?
          if csv.present?
            csv.close
            csv_file_name = build_file_name count
            FileUtils.mv tmp_csv.path, csv_file_name
            tmp_csv.close
          end
          tmp_csv = Tempfile.new
          csv = CSV.open(tmp_csv.path, 'w', **output_csv_options)
          csv << row.headers
        end
        csv << row.to_h
        count += 1
      end
      csv_file_name = build_file_name count
      csv.close if csv
      FileUtils.mv tmp_csv.path, csv_file_name
      tmp_csv.close
    end
  end
end
