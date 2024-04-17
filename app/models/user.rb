class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable , :validatable, :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  validates :email, :password, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Incorrect email format", on: [:create, :update] },
            uniqueness: { on: [:create, :update] }
end
