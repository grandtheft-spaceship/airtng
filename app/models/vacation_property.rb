class VacationProperty < ApplicationRecord
  belongs_to :user #HOST
  has_many :reservations
  has_many :users, through: :reservations #GUESTS
end
