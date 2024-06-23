# frozen_string_literal: true

require 'active_support/all'
require_relative 'csv_util/util'
require_relative 'csv_util/version'
require_relative 'csv_util/cut'

module CSVUtil
  class Error < StandardError; end
end