# frozen_string_literal: true

module CSVUtil
  class Filter
    include CSVUtil::Util
    include CSVUtil::CSVReader
    include CSVUtil::CSVWriter

    attr_reader :column, :pattern, :reject_matching, :insensitive,
                :substring, :text, :out_col_sep

    # Initialize the filter object
    # @param column [String] the column to filter on
    # @param options [Hash] the options
    # @option options [String] :in_col_sep (',') the column separator
    # @option options [String] :out_col_sep (',') the output column separator
    # @option options [String] :encoding ('utf-8') the input encoding
    # @option options [String] :text (nil) the text to match
    # @option options [Boolean] :reject_matching (nil) whether to return non matching lines
    # @option options [Boolean] :substring (nil) whether the text is a substring
    # @option options [String] :pattern (nil) the regex to match
    def initialize column, options = {}
      @column          = column
      @encoding        = options[:encoding] || CSVUtil::DEFAULT_ENCODING
      @in_col_sep      = options[:in_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @out_col_sep     = options[:out_col_sep] || CSVUtil::DEFAULT_SEPARATOR
      @pattern         = options[:pattern]
      @reject_matching = options[:reject_matching]
      @insensitive     = options[:insensitive]
      @substring       = options[:substring]
      @text            = options[:text]
    end

    def match? row
      return does_not_match? row if reject_matching
      return matches_text? row if text

      matches_pattern? row
    end

    def does_not_match? row
      return !matches_text?(row) if text
      !matches_pattern? row
    end

    def matches_text? row
      return matches_substring? row if substring

      value = row[column].to_s
      return value == text unless insensitive
      value.downcase == text.downcase
    end

    def matches_substring? row
      value = row[column].to_s
      return value.include? text unless insensitive

      value.downcase.include? text.downcase
    end

    def matches_pattern? row
      value = row[column].to_s
      flags = 0
      flags |= Regexp::IGNORECASE if insensitive
      value =~ Regexp.new(pattern, flags)
    end

    def filter input
      first_row = true
      write do |csv|
        read(input) do |row|
          if first_row
            validate_column row
            csv << row.headers
            first_row = false
          end
          csv << row.to_h if match? row
        end
      end
    end

    def validate_column row
      raise CSVUtil::Error, 'No column specified' if column.blank?
      raise CSVUtil::Error, "Column #{column} not in CSV" unless row.key? column
    end
  end
end