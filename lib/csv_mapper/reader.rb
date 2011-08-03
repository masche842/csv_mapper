require 'fastercsv'

class CsvMapper::Reader
  
  def initialize(file, mapping, ignore_first_row)
    @file = file
    @ignore_first_row = ignore_first_row
    @mapping = {}
    mapping.each do |k, v|
      unless v.empty?
        @mapping[v.downcase.to_sym] = k.to_i - 1
      end
    end
  end
  
  def each
    row_number = 1
    FasterCSV.foreach(@file, CsvMapper.options) do |csv_row|
      unless row_number == 1 && @ignore_first_row
        row = {}
        @mapping.each do |k, v|
          row[k] = csv_row[v]
        end
        row.class.send(:define_method, :number) { row_number }
        yield(row)
      end
      row_number += 1
    end
  end
  
end
