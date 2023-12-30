require 'rails_helper'

include Helpers

describe "Beers page" do
  before :each do
    FactoryBot.create :beer
  end

  describe "create new beer" do
    before :each do
      visit new_beer_path

      expect(page).to have_content("New beer")
    end
    it "with valid name succeeds" do
      fill_in('beer_name', with: "testi")

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)
    end

    it "with an invalid name fails" do
      click_button('Create Beer')

      expect(page).to have_content "Name can't be blank"
    end
  end
end