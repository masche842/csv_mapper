class PeopleController < ApplicationController

  include CsvMapper::ControllerActions

  csv_mapper_config(
    :mapping => {
      "Firstname" => :firstname,
      "Lastname"  =>  :lastname
    }
  )

  # GET /people
  def index
    @people = Person.all
  end

  # DELETE /people/1
  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    redirect_to(people_url)
  end

end