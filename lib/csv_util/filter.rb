# frozen_string_literal: true

module CSVUtil
  class Filter < CSVUtil::Command

    attr_reader :column
    attr_reader :input

    attr_reader :insensitive
    attr_reader :pattern
    attr_reader :reject_matching
    attr_reader :substring
    attr_reader :text

    # Initialize the filter object
    # @param column [String] the column to filter on
    # @param options [Hash] the options
    # @option options [String] :text (nil) the text to match
    # @option options [Boolean] :reject_matching (nil) whether to return non matching lines
    # @option options [Boolean] :substring (nil) whether the text is a substring
    # @option options [String] :pattern (nil) the regex to match
    def initialize input, column, options = {}
      @input          = input
      @column          = column
      @reject_matching = options[:reject_matching]
      @pattern         = options[:pattern]
      @insensitive     = options[:insensitive]
      @substring       = options[:substring]
      @text            = options[:text]

      super options
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

    # Process the input CSV, writing the result to the output
    def process
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