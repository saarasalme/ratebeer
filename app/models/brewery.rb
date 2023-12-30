# frozen_string_literal: true

class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :year, numericality: { only_integer: true }
  validate :year_not_less_than_1040_and_not_in_the_future

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  private

  def year_not_less_than_1040_and_not_in_the_future
    if year < 1040
      errors.add(:year, "Cannot be less than 1040")
    end
    return unless year > Date.today.year

    errors.add(:year, "Cannot be in the future")
  end
end
