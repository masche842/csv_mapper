require 'fastercsv'

class CsvMapper::Importer
  attr_reader :map_fields, :filename


  def initialize(params, options)
    @file_handler = CsvMapper::FileHandler.new()

    if @file_handler.save_temp_file(params[options[:file_field]])
      set_attributes_from_valid_file(options)
    else
      raise CsvMapper::MissingFileContentsError
    end
  end

  def raw_data
    FasterCSV.read(@file_handler.file_path, CsvMapper.options)
  end

private

  def set_attributes_from_valid_file(options)
    @filename = @file_handler.filename
    @map_fields = options[:mapping]
  end

end