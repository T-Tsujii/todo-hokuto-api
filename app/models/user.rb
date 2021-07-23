# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :recoverable,
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :tasks, dependent: :destroy
end