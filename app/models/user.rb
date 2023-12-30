class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4},
                       format: { with: /(?=.*\d)(?=.*[A-Z])/,
                                 message: "Must have at least one uppercase letter and one number" }

  has_many :ratings, dependent: :destroy   # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, -> { distinct }, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
  
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    beers.group(:style).count.sort_by{ |_,value| value }.reverse[0][0]
  end

  def favorite_brewery
    return nil if beers.empty?
    beers.select(:brewery_id).distinct.map(&:brewery).sort_by(&:average_rating).reverse[0]
  end
end
