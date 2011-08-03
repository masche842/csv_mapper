require "csv_mapper/version"

require 'csv_mapper/controller_actions'
require 'csv_mapper/engine'
require 'csv_mapper/importer'
require 'csv_mapper/reader'

module CsvMapper

  FCSV_OPTIONS 	= 	{
      :col_sep => ";",
      :row_sep => :auto,
      :quote_char => '"',
      :converters => nil,
      :unconverted_fields => nil,
      :headers => false,
      :return_headers => false,
      :header_converters => nil,
      :skip_blanks => false,
      :force_quotes => false
  }.freeze

  def self.included(base)
    base.extend(ClassMethods)
  end

  def mapped_fields
    @mapped_fields
  end

  def fields_mapped?
    raise @map_fields_error if @map_fields_error
    @mapped_fields
  end

  def map_field_parameters(&block)

  end

  def map_fields_cleanup
    if @mapped_fields
      if session[:map_fields][:file]
        File.delete(session[:map_fields][:file])
      end
      session[:map_fields] = nil
      @mapped_fields = nil
      @map_fields_error = nil
    end
  end

  class InconsistentStateError < StandardError
  end

  class MissingFileContentsError < StandardError
  end

  class ParamsParser
    def self.parse(params, field = nil)
      result = []
      params.each do |key,value|
        if field.nil? || field.to_s == key.to_s
          check_values(value) do |k,v|
            result << ["#{key.to_s}#{k}", v]
          end
        end
      end
      result
    end

    private
    def self.check_values(value, &block)
      result = []
      if value.kind_of?(Hash)
        value.each do |k,v|
          check_values(v) do |k2,v2|
            result << ["[#{k.to_s}]#{k2}", v2]
          end
        end
      elsif value.kind_of?(Array)
        value.each do |v|
          check_values(v) do |k2, v2|
            result << ["[]#{k2}", v2]
          end
        end
      else
        result << ["", value]
      end
      result.each do |arr|
        yield arr[0], arr[1]
      end
    end
  end
end
