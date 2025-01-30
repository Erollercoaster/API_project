class User < ApplicationRecord
    has_many :tasks
    has_many :remarks, through: :tasks
  
    validates :first_name, :last_name, presence: true
  end