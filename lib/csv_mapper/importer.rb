require 'fastercsv'

class CsvMapper::Importer
  attr_accessor :map_fields, :raw_data, :file_path

  def initialize(params, options)
    @params = params
    temp_file = params[options[:file_field]]

    @file_path = params[:file_path] || ( temp_file.path unless temp_file.nil? )

    if @file_path
      @raw_data = FasterCSV.open(@file_path, CsvMapper.options)
      @map_fields = options[:mapping]
    else
      raise CsvMapper::MissingFileContentsError
    end
  end

  def data
    CsvMapper::Reader.new(
      @file_path,
      @params[:fields],
      @params[:ignore_first_row]
    )
  end
end