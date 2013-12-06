require 'spec_helper.rb'

    #_x_ syllabic: a rhyme in which the last syllable of each word sounds the same but does not necessarily contain vowels. (cleaver, silver, or pitter, patter)
    #_x_ imperfect (or near): a rhyme between a stressed and an unstressed syllable. (wing, caring)
    #_x_ weak (or unaccented): a rhyme between two sets of one or more unstressed syllables. (hammer, carpenter)
    #_x_ assonance: matching vowels. (shake, hate) Assonance is sometimes referred to as slant rhymes, along with consonance.
    #_x_ consonance: matching consonants. (rabies, robbers)
    #___ semirhyme: a rhyme with an extra syllable on one word. (bend, ending)
    #___ forced (or oblique): a rhyme with an imperfect match in sound. (green, fiend; one, thumb)
    #___ half rhyme (or slant rhyme): matching final consonants. (bent, ant)
    #___ pararhyme: all consonants match. (tell, tall)
    #___ alliteration (or head rhyme): matching initial consonants. (short, ship)

module Rhymedas
  describe 'Detector' do
    it 'Correctly classifies each type of rhyme' do
      TEST_PAIRS.each do |entry|
        word1, word2 = entry[0]
        expected = entry[1]

        expected.each do |rhyme|

          has_rhyme = Detector.send("have_#{rhyme}_rhyme?", word1, word2)
          has_rhyme.should be_true
        end
      end
    end
  end
end
