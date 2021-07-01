class Task < ApplicationRecord
  validates :body, presence: true
end
