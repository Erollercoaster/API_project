class Task < ApplicationRecord
    belongs_to :user
    has_many :remarks, dependent: :destroy
  
    validates :name, :due_date, presence: true
  end