# frozen_string_literal: true

require 'rails_helper'

describe Pump do
  context 'when checking whether pump is on/off' do
    let(:pump) { create(:pump) }

    context 'it returns the correct value when #on? is called' do
      it 'returns true when #on? is called and the pump is on' do
        create(:pump_state, pump:, active: true)
        expect(pump.on?).to be(true)
      end

      it 'returns false when #on? is called and the pump is off' do
        create(:pump_state, pump:, active: false)
        expect(pump.on?).to be(false)
      end
    end

    context 'it returns the correct value when #on? is called' do
      it 'returns false when #off? is called and the pump is on' do
        create(:pump_state, pump:, active: true)
        expect(pump.off?).to be(false)
      end

      it 'returns true when #ff? is called and the pump is on' do
        create(:pump_state, pump:, active: false)
        expect(pump.off?).to be(true)
      end
    end
  end
end
