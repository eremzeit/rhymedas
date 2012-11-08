require 'spec_helper.rb'

module Rhymedas
  describe 'Detector' do
    it 'does stuff' do
      Detector.analyze('RABIES', 'ROBBERS')
      Detector.analyze('CONTINUE', 'YOU')
      Detector.analyze('HEATER', 'CLEAVER')
      Detector.analyze('READ', 'CAT')
      Detector.analyze('WIRE', 'FIRE')
      Detector.analyze('SHAKE', 'HATE')
    end
  end
end
