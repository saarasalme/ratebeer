require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved without a proper password" do
    user = User.create username: "Pekka", password: "moi", password_confirmation: "moi"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite_style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "with two Lagers and one IPA, it's Lager" do
      create_beers_with_many_ratings({ user: user }, 10, 14)
      FactoryBot.create(:beer, style: "IPA")

      expect(user.favorite_style).to eq("Lager")
    end
  end
end # describe User

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

describe "favorite_brewery" do
  let(:user){ FactoryBot.create(:user) }

  it "has method for determining one" do
    expect(user).to respond_to(:favorite_brewery)
  end

  it "without ratings does not have one" do
    expect(user.favorite_brewery).to eq(nil)
  end

  it "with two Breweries, it's the one with higher ratings" do
    brewery1 = FactoryBot.create(:brewery)
    brewery2 = FactoryBot.create(:brewery, name: "anonymous2")

    create_beers_with_many_ratings({ user: user, brewery: brewery1 }, 15, 16)
    create_beer_with_rating({ user: user, brewery: brewery2 }, 12)


    expect(user.favorite_brewery).to eq(brewery1)
  end

  def create_beer_with_rating(object, score)
    if object.include?(:brewery)
      beer = FactoryBot.create(:beer, brewery: object[:brewery])
    else
      beer = FactoryBot.create(:beer)
    end
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end
end