require 'spec_helper'

describe CsvMapper do
  include Capybara::DSL

  it "should be valid" do
    CsvMapper.should be_a(Module)
  end

  describe "Dummy-Application" do

    it "should be a valid app" do
      ::Rails.application.should be_a(Dummy::Application)
    end

    describe "CsvMapper-Integration" do
      it "should add an import-action" do
        PeopleController.new.should respond_to("import")
      end
    end

  end
end
