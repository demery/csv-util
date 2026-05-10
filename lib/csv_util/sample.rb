# frozen_string_literal: true

module CSVUtil
  class Sample < Command
    attr_reader :input, :count, :seed

    def initialize input, options = {}
      @input = input
      @count = options[:count] || 1
      @seed  = options[:seed]
      super options
    end

    def process
      srand(seed) if seed

      reservoir = []
      headers   = nil
      i         = 0

      read(input) do |row|
        headers ||= row.headers
        if i < count
          reservoir << row
        else
          j = rand(i + 1)
          reservoir[j] = row if j < count
        end
        i += 1
      end

      write do |csv|
        csv << headers
        reservoir.each { |row| csv << row }
      end
    end
  end
end
