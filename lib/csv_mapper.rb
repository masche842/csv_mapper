require "csv_mapper/version"
require 'csv_mapper/controller_actions'
require 'csv_mapper/engine'
require 'csv_mapper/importer'
require 'csv_mapper/reader'

module CsvMapper

  class InconsistentStateError < StandardError
  end

  class MissingFileContentsError < StandardError
  end

  @@options = {
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

  def self.options
    @@options
  end

  def self.options=(options)
    @@options = options
  end

end
