require 'spec_helper.rb'

module Rhymedas
  describe SyllableMaker do
    describe 'number of syllables' do
      [ ['EARTH', 1],
        ['FOLLOWER', 3],
        ['LIVINGS', 2],
        ['BORED', 1],
        ['MEXICAN', 3],
        ['BEAUTIFUL', 3],
        ['DAFT', 1]
      ].each do |input|
        it "#{input[0]}" do
          SyllableMaker.guess_syllables(Words.phonemes(input[0])).length.should == input[1]
        end
      end
      it 'test a word' do
        pending
        #puts SyllableMaker.guess_syllables(Words.phonemes('daft'))
      end
    end
  end
end
