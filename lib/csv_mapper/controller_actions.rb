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
            :params => [],
            :mapping => {},
            :file_field => 'file'
        }
        options = defaults.merge(options)
        write_inheritable_attribute(:map_fields_options, options)
        #before_filter :map_fields, :only => options[:action]
        #after_filter :map_fields_cleanup, :only => options[:action]
      end
    end

    def import
      debugger
      if request.post?
        @mapped_fields = CsvMapper::Importer.new(params)
        if @mapped_fields

          save_errors = []
          #TODO Guest.new(@mapped_fields)
          @mapped_fields.each do |row|
            guest = Guest.new(
                :event => @event,
                    :confirmed  => false,
                    :svr_identifier => row[:svr_identifier],
                    :svr_notes => row[:svr_notes]
            )
            guest.build_person(
                :title => row[:title],
                    :lastname  =>  row[:lastname],
                    :firstname  => row[:firstname],
                    :jobtitle => row[:jobtitle]
            )
            guest.build_company(:name => row[:company])

            unless guest.save
              save_errors.push guest.errors
            end
          end
          if save_errors.empty?
            flash[:notice] = 'Daten erfolgreich importiert!'
            redirect_to :action => :index
          else
            flash[:warning] = save_errors
            render
          end
        else
          render "mapper"
        end
      else
        render 'import'
      end
    rescue CsvMapper::InconsistentStateError
      flash[:warning] = 'unbekannter Fehler.'
    rescue CsvMapper::MissingFileContentsError
      flash[:warning] = 'Bitte eine CSV-Datei hochladen.'
      render
    end

  end
end
