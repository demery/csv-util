#!/usr/bin/env ruby

require 'optparse'
require 'csv'

DEFAULT_ENCODING = 'utf-8'

########################################################################
# Methods
########################################################################

##
# Either regex or text must be provided, but not both.
#
def valid_match? options
  options[:regex_string].nil? ^ options[:text].nil?
end


def match? row, options
  value = row[options[:column]]
  return value == options[:text] unless options[:text].nil?

  value =~ options[:regex]
end

########################################################################
# Options
########################################################################

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: csvfilter.rb --column=COLUMN_NAME {--regex|--value}=VALUE CSV_FILE"

  opts.on "-c", "--column COLUMN_NAME", "Column to filter on" do |col|
    options[:column] = col
  end

  opts.on("-r", "--regex PATTERN",
          "Ruby regular expression; e.g., 'trade.*cards'") do |regex_string|
    options[:regex_string] = regex_string
  end

  opts.on "-i", "--case-insensitive", "Whether match is case-insensitive" do
    options[:insensitive] = true
  end

  opts.on "-t", "--text TEXT", "An exact string to match" do |text|
    options[:text] = text
  end

  opts.on "-e", "--encoding ENCODING" do |encoding|
    options[:encoding] = encoding
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

abort 'Please provide a CSV_FILE' unless ARGV.size == 1
csv_file = ARGV.shift

abort "Can't find CSV_FILE: '#{csv_file}'" unless File.exist? csv_file

# Handle options
encoding = options[:encoding] || DEFAULT_ENCODING
abort 'Provide either a regex or text to match' unless valid_match? options
abort 'Specify a column to match' unless options[:column]

unless options[:regex_string].nil?
  options[:regex] = Regexp.new options[:regex_string], options[:insensitive]
end

headers = CSV.open(csv_file, 'r') { |csv| csv.first }

CSV.open 'out.csv', 'wb', headers: true do |out_csv|
  out_csv << headers
  CSV.foreach csv_file, headers: true, encoding: "#{encoding}:utf-8" do |row|
    out_csv << row if match? row, options
  end
end

