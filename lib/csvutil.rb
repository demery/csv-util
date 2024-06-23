# frozen_string_literal: true

require 'active_support/all'
require_relative 'csv_util/version'
require_relative 'csv_util/cut'
require_relative 'csv_util/util'

module CSVUtil
  class Error < StandardError; end
end
