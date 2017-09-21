class Event < ApplicationRecord
  PERIODS = %w(second minute hour day week month)

  validates :frequency_quantity, presence: true, numericality: true
  validates :period, presence: true, inclusion: { in: PERIODS }

  validates :image, presence: true
  validates :command, presence: true

  def frequency
    frequency_quantity.send(period.pluralize)
  end

  def schedule
    "#{frequency_quantity} #{period.pluralize}"
  end
end
