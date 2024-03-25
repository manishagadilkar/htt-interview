# Telemetry data sent from a lift station reports the state of the pump (on/off).
# The station reports every two minutes.
# The state of the pump does not necessarily change each time the station reports.
#
# For the sake of the assignment, assume the pump state did not change between reports, rather the
# the pump switched on/off exactly when the telemtry message was sent. (e.g. pump runs for 6 minutes)
# app/models/telemetry/pump_state.rb
module Telemetry
  class PumpState < ApplicationRecord
    self.table_name = 'pump_states'
    belongs_to :pump

    before_create :evaluate_pump_cycle

    private

    # Evaluates the pump cycle to start or end a cycle based on the state reported by telemetry.
    def evaluate_pump_cycle
      if active && pump_was_off?
        # Start a new PumpCycle if the pump was previously off.
        PumpCycle.create!(pump:, started_at: reported_at)
      elsif !active && pump_was_on?
        # End the current PumpCycle if the pump was previously on.
        current_cycle = pump.pump_cycles.unfinished.last
        # Here we avoid using `create!` and `update!` to prevent raising exceptions.
        # This should be handled according to the specific requirements of your application.
        current_cycle&.update(duration: (reported_at - current_cycle.started_at).to_i)
      end
    end

    # Determines if the pump was off before the current state was reported.
    def pump_was_off?
      last_state_before_report.active == false
    end

    # Determines if the pump was on before the current state was reported.
    def pump_was_on?
      last_state_before_report.active == true
    end

    # Retrieves the last reported state before the current one.
    def last_state_before_report
      pump.pump_states.where('reported_at < ?',
                             reported_at).order(reported_at: :desc).first || OpenStruct.new(active: false)
    end
  end
end
