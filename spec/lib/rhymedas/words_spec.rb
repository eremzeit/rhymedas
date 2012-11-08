require 'spec_helper.rb'

module Rhymedas
  describe Words do
    it 'has less than 50K words for testing' do
      (Words.count < 50000).should == true
    end
    describe '#phonemes' do
      it 'returns phonemes' do
        Words.phonemes('apple').length.should == 4
      end
    end
    describe '#syllables' do
      it 'returns syllables' do
        Words.syllables('apple').length.should == 2
      end
    end
  end
end
