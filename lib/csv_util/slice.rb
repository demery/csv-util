# frozen_string_literal: true

module CSVUtil
  class Slice < Command

    attr_reader :input
    attr_reader :slice_spec
    attr_reader :reject

    def initialize input, options = {}
      @input      = input
      @slice_spec = options[:slice_spec]
      @reject     = options[:reject]

      super options
    end

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
      when /\A(\d+)\.\.\z/
        @range = (Integer($1)..)
      else
        raise ArgumentError,"Invalid slice specification: '#{slice_spec}'"
      end
    end

    def in_slice? index
      range.include? index
    end

    def process
      index = 0
      write do |csv|
        read input do |row|
          csv << row.headers if index.zero?
          passes = in_slice?(index + 1)
          csv << row if reject ? !passes : passes
          index += 1
        end
      end
    end
  end
end
