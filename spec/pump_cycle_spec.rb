# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PumpCycle, type: :model do
  let(:pump) { create(:pump) } # Assuming the factory sets the pump to off by default

  describe 'pump cycle creation' do
    context 'when pump states change' do
      it 'starts a new cycle when the pump was off and is now on' do
        expect do
          create(:pump_state, pump:, active: true)
        end.to change(PumpCycle.for_pump(pump), :count).by(1)
      end

      it 'sets the correct duration when a pump cycle ends' do
        start_time = Time.zone.now
        create(:pump_state, pump:, active: true, reported_at: start_time)

        expect do
          end_time = start_time + 120.seconds
          create(:pump_state, pump:, active: false, reported_at: end_time)
          last_cycle = PumpCycle.for_pump(pump).last
          last_cycle.update(duration: (end_time - last_cycle.started_at).to_i)
        end.to change {
          PumpCycle.for_pump(pump).last.duration
        }.from(nil).to(120)
      end
    end
  end
end
