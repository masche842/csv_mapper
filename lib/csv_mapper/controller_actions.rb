require 'fastercsv'

module CsvMapper
  module ControllerActions
    
    def self.included(base)
      base.extend(ClassMethods)
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
        @mapper = CsvMapper::Importer.new(params, self.class.read_inheritable_attribute(:map_fields_options))
        if params[:fields]
          save_errors = []
          @mapper.data.each do |row|
            resource = resource_class.new(row)
            unless resource.save
              save_errors.push resource.errors
            end
          end
          if save_errors.empty?
            flash[:notice] = 'Daten erfolgreich importiert!'
            redirect_to :action => :index
          else
            flash[:warning] = save_errors
            render 'controller_actions/import'
          end
        else
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
    end
    
  end
end
