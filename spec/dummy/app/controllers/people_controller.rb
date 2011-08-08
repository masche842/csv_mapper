class PeopleController < ApplicationController

  include CsvMapper::ControllerActions

  csv_mapper_config(
    :mapping => {
      "Firstname" => :firstname,
      "Lastname"  =>  :lastname
    }
  )
end