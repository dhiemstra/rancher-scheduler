class Event < ApplicationRecord
  def frequency
    frequency_quantity.send(period.pluralize)
  end
end
