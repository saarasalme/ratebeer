require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  
  describe "who has signed in" do
    let!(:user) { User.first }
    let!(:brewery) { FactoryBot.create :brewery }
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
      create_multiple_ratings({ user: user }, 10, 15, 13)
      visit user_path(user)
    end

    it "shows created ratings on user's page" do
      user2 = FactoryBot.create :user, username: "test", password: "Foobar1"
      create_multiple_ratings({ user: user2 }, 5, 20)

      expect(page).to have_content 'anonymous 10'
      expect(page).to have_content 'anonymous 15'
      expect(page).to have_content 'anonymous 13'
      expect(page).to_not have_content 'anonymous 5'
      expect(page).to_not have_content 'anonymous 20'
    end

    it "can delete own ratings" do
      within('li', text: 'anonymous 10') do
        click_link('Delete')
      end

      expect(current_path).to eq(user_path(user.id))
      expect(page).to_not have_content 'anonymous 10'
    end
    
    it "shows favorite brewery and beer on page" do
      beer = FactoryBot.create :beer, name: "test", style: "test"
      FactoryBot.create :rating, beer: beer, user: user, score: 12

      expect(page).to have_content "Favorite brewery: #{user.favorite_brewery.name}"
      expect(page).to have_content "Favorite style: #{user.favorite_style}"
    end
  end
end

def create_multiple_ratings(object, *scores)
  scores.each do |score|
    if object.include?(:user)
      FactoryBot.create :rating, user: object[:user], score: score
    else
      FactoryBot.create :rating, score: score
    end
  end
end