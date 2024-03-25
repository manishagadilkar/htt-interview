# calculates estimates for the
#  -inflow rate
#  - flow rate
#  - flow total
# and creates a new LiftStationCycle to record the data
class LiftStationFlowEstimator
  attr_reader :lift_station, :pump_cycle

  def initialize(lift_station:, pump_cycle:)
    @lift_station = lift_station
    @pump_cycle = pump_cycle
  end

  # calculate the values and create a new LiftStationCycle to record
  def perform
    LiftStationCycle.create(
      inflow_rate: inflow_rate,
      outflow_rate: outflow_rate,
      flow_total: flow_total,
      lift_station_id: lift_station.id
    )
  end

  # represents the rate of liquid flow into a lift station tank
  def inflow_rate
    estimated_inflow_rate = 100 # litres per minute as an example
    estimated_inflow_rate
  end

  # the total amount of liquid pumped out of the tank
  # NOTE: this should include the amount of liquid that flowed into the tank
  #       while the pump ran because water does not stop flowing into the tank
  #       while the pump is on
  # use the most recent inflow rate as an estimate
  def flow_total
    inflow_rate * pump_cycle.duration + lift_station.lead_to_off_volume
  end

  # represents the rate of liquid pumped out of the tank
  def outflow_rate
    lift_station.lead_to_off_volume / pump_cycle.duration
  end
end
