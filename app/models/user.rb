class User < ApplicationRecord
  has_many :vacation_properties
  has_many :reservations, through: :vacation_properties

  has_secure_password

  validates :email, presence: true, format: { with: /\A.+@.+$\Z/ }, uniquness: true
  validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates_length_of :password, in: 6..20, on: :create

end
