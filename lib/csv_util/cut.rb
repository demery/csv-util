require  'csv'

class CSVUtil::Cut
  attr_reader :columns
  attr_reader :in_col_sep
  attr_reader :out_col_sep
  attr_reader :print_headers

  def initialize columns, options: {}
    @columns       = columns
    @in_col_sep    = options[:in_col_sep] || ','
    @out_col_sep   = options[:out_col_sep] || ','
    @print_headers = options[:print_headers]
  end

  def process input
    CSV col_sep: out_col_sep do |csv|
      first_row = true
      CSV.parse input, headers: true, col_sep: out_col_sep do |row|
        if print_headers && first_row
          csv << row.heads
          first_row = false
        end
        csv << columns.map { |column| row[column] }
      end
    end
  end
end
