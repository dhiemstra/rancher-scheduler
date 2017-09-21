class Event < ApplicationRecord
  validates :frequency_quantity, presence: true, numericality: true
  validates :period, presence: true, inclusion: { in: %w(second minute hour day week month) }

  validates :image, presence: true
  validates :command, presence: true

  def frequency
    frequency_quantity.send(period.pluralize)
  end
end
