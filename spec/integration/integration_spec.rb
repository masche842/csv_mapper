require "spec_helper"

describe CsvMapper do
  it "should be valid" do
    CsvMapper.should be_a(Module)
  end
end

describe "Integration" do
  it "adds an import action to a controller" do

  end

  describe "import" do

    context "when csv is given as param" do
      it "renders the mapper view"
    end
    context "when mapping and filename is given as param" do
      it "saves the csv-lines as resource-objects"
    end
    context "when csv has been imported" do
      it "redirects to resources index"
    end

  end

end