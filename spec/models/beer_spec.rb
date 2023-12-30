require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    it "is saved with a proper name and style" do
      beer = Beer.create name: "Olut", style: "Lager", brewery: test_brewery

      expect(beer.valid?).to be(true)
      expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
      beer = Beer.create style: "Lager", brewery: test_brewery

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.create name: "Olut", brewery: test_brewery

      expect(beer.valid?).to be(false)
      expect(Beer.count).to eq(0)
    end
  end
end