# frozen_string_literal: true

# represents a pump at a lift station
class Pump < ApplicationRecord
  has_one :lift_station, dependent: :destroy
  has_many :pump_states, class_name: 'Telemetry::PumpState', dependent: :nullify
  has_many :pump_cycles, dependent: :destroy

  def on?
    pump_states.last&.active
  end

  def off?
    !on?
  end
end
