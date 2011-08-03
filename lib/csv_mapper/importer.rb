class CsvMapper::Importer
  def initialize( params )

    options =  self.class.read_inheritable_attribute(:map_fields_options)

    if session[:map_fields].nil? || params[options[:file_field]]
      session[:map_fields] = {}
      if params[options[:file_field]].blank?
        @map_fields_error = CsvMapper::MissingFileContentsError
        return
      end

      file_field = params[options[:file_field]]

      temp_path = File.join(Dir::tmpdir, "map_fields_#{Time.now.to_i}_#{$$}")
      File.open(temp_path, 'wb') do |f|
        f.write file_field.read
      end

      session[:map_fields][:file] = temp_path

      @rows = []
      FasterCSV.foreach(temp_path, FCSV_OPTIONS) do |row|
        @rows << row
        break if @rows.size == 10
      end

      @fields = options[:mapping]

      @parameters = []
      options[:params].each do |param|
        @parameters += ParamsParser.parse(params, param)
      end
    else
      if session[:map_fields][:file].nil? || params[:fields].nil?
        session[:map_fields] = nil
        @map_fields_error =  CsvMapper::InconsistentStateError
      else
        @mapped_fields = CsvMapper::Reader.new(
            session[:map_fields][:file],
                params[:fields],
                params[:ignore_first_row])
      end
    end
  end
end