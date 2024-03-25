# frozen_string_literal: true

require 'rails_helper'

describe LiftStation do
  let(:lift_station) { create(:lift_station, radius: 3, height: 10, lead_to_floor: 8, off_to_floor: 2) }

  describe '#total_tank_volume' do
    it 'is implemented' do
      expect { lift_station.total_tank_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      # The expected volume is π * radius^2 * height
      expected_volume = Math::PI * (lift_station.radius**2) * lift_station.height
      expect(lift_station.total_tank_volume).to eq(expected_volume)
    end
  end

  describe '#lead_to_off_volume' do
    it 'is implemented' do
      expect { lift_station.lead_to_off_volume }.not_to raise_error(NotImplementedError)
    end

    it 'returns the correct volume' do
      # The expected volume is π * radius^2 * (lead_to_floor - off_to_floor)
      expected_volume = Math::PI * (lift_station.radius**2) * (lift_station.lead_to_floor - lift_station.off_to_floor)
      expect(lift_station.lead_to_off_volume).to eq(expected_volume)
    end
  end
end
