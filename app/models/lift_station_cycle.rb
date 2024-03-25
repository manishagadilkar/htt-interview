# frozen_string_literal: true

# calculated after the end of a pump_cycle
# contains estimations for:
#  - inflow rate
#  - outflow rate
#  - total flow volume
class LiftStationCycle < ApplicationRecord
  belongs_to :lift_station
end
