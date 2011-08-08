class PeopleController < ApplicationController

  include CsvMapper::ControllerActions

  csv_mapper_config(
    :mapping => {
      "Firstname" => :firstname,
      "Lastname"  =>  :lastname
    }
  )

  # GET /my_models
  def index
    @people = Person.all
  end
end