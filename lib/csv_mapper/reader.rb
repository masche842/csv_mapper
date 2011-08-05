require 'fastercsv'

class CsvMapper::Reader
  
  def initialize(params)
    @file_handler = CsvMapper::FileHandler.new
    @file_handler.load_file(params[:filename])

    @file_path = @file_handler.file_path
    @ignore_first_row = params[:ignore_first_row]
    @mapping = {}
    params[:fields].each do |k, v|
      unless v.empty?
        @mapping[v.downcase.to_sym] = k.to_i - 1
      end
    end
  end
  
  def each
    row_number = 1
    FasterCSV.foreach(@file_path, CsvMapper.options) do |csv_row|
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

  def remove_file
    @file_handler.remove_file
  end

end
