require 'fastercsv'

module CsvMapper
  module ControllerActions
    
    def self.included(base)
      base.extend(ClassMethods)
      base.csv_mapper_config
    end
    
    module ClassMethods
      def csv_mapper_config( options = {} )
        defaults = {
          :action => :import,
          :mapping => {},
          :file_field => :file
        }
        options = defaults.merge(options)
        write_inheritable_attribute(:map_fields_options, options)
      end
    end

    def import
      resource_name = self.class.name.gsub(/Controller/, '').singularize
      resource_class = resource_name.constantize
      if request.post?
        # already mapped
        if params[:fields]
          create_resource_items_from_csv(resource_class)
          if @csv_import_errors.empty?
            flash[:notice] = 'Daten erfolgreich importiert!'
            redirect_to :action => :index
          else
            flash[:warning] = @csv_import_errors
            redirect_to :back
          end
        #no mapping yet
        else
          @mapper = CsvMapper::Importer.new(params, self.class.read_inheritable_attribute(:map_fields_options))
          @raw_data = @mapper.raw_data
          render 'controller_actions/mapper'
        end
      else
        render 'controller_actions/import'
      end
    rescue CsvMapper::InconsistentStateError
      flash[:warning] = 'unbekannter Fehler.'
    rescue CsvMapper::MissingFileContentsError
      flash[:warning] = 'Bitte eine CSV-Datei hochladen.'
      render 'controller_actions/import'
    rescue FasterCSV::MalformedCSVError => e
      flash[:warning] = 'Fehlerhaft formatierte CSV-Datei: ' + e
      render 'controller_actions/import'
    rescue Errno::ENOENT
      flash[:warning] = 'Datei nicht mehr auf dem Server. Bitte erneut hochladen!'
      render 'controller_actions/import'
    end

private
    def create_resource_items_from_csv(resource_class)
      @csv_import_errors = []
      reader = CsvMapper::Reader.new(params)
      reader.each do |row|
        resource = resource_class.new(row)
        unless resource.save
          @csv_import_errors.push resource.errors
        end
      end
      reader.remove_file if @csv_import_errors.empty?
    end
    
  end
end
