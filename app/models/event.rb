class Event < ApplicationRecord
  PERIODS = %w(second minute hour day week month)

  validates :frequency_quantity, presence: true, numericality: true
  validates :period, presence: true, inclusion: { in: PERIODS }

  validates :image, presence: true
  validates :command, presence: true

  def skip_first_run
    true
  end

  def frequency
    frequency_quantity.send(period.pluralize)
  end

  def schedule
    "#{frequency_quantity} #{period.pluralize(frequency_quantity)}"
  end
end
