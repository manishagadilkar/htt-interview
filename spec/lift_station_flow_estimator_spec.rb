# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LiftStationFlowEstimator, type: :service do
  subject { described_class.new(lift_station:, pump_cycle:) }

  let(:lift_station) { instance_double(LiftStation, id: 1, lead_to_off_volume: 3000) }
  let(:pump_cycle) { instance_double(PumpCycle, duration: 30) } # Duration in minutes

  describe '#perform' do
    it 'creates a new LiftStationCycle with the correct attributes' do
      allow(subject).to receive_messages(inflow_rate: 100, outflow_rate: 100, flow_total: 5000)

      expect(LiftStationCycle).to receive(:create).with(
        inflow_rate:     100,
        outflow_rate:    100,
        flow_total:      5000,
        lift_station_id: lift_station.id
      )

      subject.perform
    end
  end

  describe '#inflow_rate' do
    it 'returns the estimated inflow rate' do
      expect(subject.inflow_rate).to eq(100)
    end
  end

  describe '#flow_total' do
    it 'calculates the total flow including inflow during pump operation' do
      estimated_total_flow = (100 * 30) + 3000
      expect(subject.flow_total).to eq(estimated_total_flow)
    end
  end

  describe '#outflow_rate' do
    it 'calculates the rate at which water is pumped out of the tank' do
      estimated_outflow_rate = 3000 / 30
      expect(subject.outflow_rate).to eq(estimated_outflow_rate)
    end
  end
end
