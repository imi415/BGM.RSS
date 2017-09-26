class Feed < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true
  validates :url, presence: true
end
