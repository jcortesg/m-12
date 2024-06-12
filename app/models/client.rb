class Client < ApplicationRecord
  has_many :orders, dependent: :nullify

  validates :nombre, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
