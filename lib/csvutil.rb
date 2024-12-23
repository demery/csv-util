# frozen_string_literal: true

require 'active_support/all'
require_relative 'csv_util/constants'
require_relative 'csv_util/version'
require_relative 'csv_util/csv_reader'
require_relative 'csv_util/csv_writer'
require_relative 'csv_util/util'
require_relative 'csv_util/cut'
require_relative 'csv_util/filter'
require_relative 'csv_util/split'
require_relative 'csv_util/slice'

module CSVUtil
  include CSVUtil::Constants
  class Error < StandardError; end
end