require 'fastercsv'

class CsvMapper::Importer
  attr_accessor :map_fields, :raw_data, :filename

  def initialize(params, options)
    @params = params

    file_handler = CsvMapper::FileHandler.new()
    if file_handler.save_temp_file(params[options[:file_field]])
      @filename = file_handler.filename
      @raw_data = FasterCSV.open(file_handler.file_path, CsvMapper.options)
      @map_fields = options[:mapping]
    else
      raise CsvMapper::MissingFileContentsError
    end
  end
end