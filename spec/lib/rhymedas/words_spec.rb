require 'spec_helper.rb'

module Rhymedas
  describe Words do
    it 'has less than 50K words for testing' do
      (Words.count < 50000).should == true
    end
    describe '#phonemes' do
      it 'returns phonemes' do
        Words.phonemes('apple').class.should == Array
      end
      it 'returns nil if word not found' do
        lambda { Words.phonemes('superfragalistic') }.should raise_error
      end
    end
    describe '#syllables' do
      it 'returns syllables' do
        Words.syllables('apple').class.should == Array
      end
      it 'returns nil if word not found' do
        lambda { Words.syllables('superfragalistic') }.should raise_error
      end
    end
  end
end
