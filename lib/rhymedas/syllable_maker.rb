module Rhymedas
  class SyllableMaker
    PAIRS = [
              ['C','T'],
              ['L','T'],
              ['L','D'],
              #['N','T'],
              ['S','T'],
            ]
    def self.guess_syllables(phonemes)
      #break up phonemes into groups by the included accents
      phonemes = phonemes.dup
      syllables = []
      while not phonemes.empty?
        seen_vowel = false
        syllable = Syllable.new
        while true
          break if phonemes.empty?

          _vowel = phonemes[0] =~ /[0-9]/
          break if _vowel && seen_vowel

          p = phonemes.slice!(0)
          if _vowel
            syllable.stress = Integer(p[_vowel])
            seen_vowel = true
            p = p.gsub(/[0-9]/, '')
          end
          syllable << p

          if !_vowel && seen_vowel
            if is_pair(p, phonemes.slice(0))
              p = phonemes.slice!(0)
              syllable << p
            end
            break
          end
        end

        syllables << syllable
      end
      syllables
    end

    def self.is_pair(c1, c2)
      PAIRS.each do |pair|
        return true if c1 == pair[0] && c2 == pair[1]
      end
      false
    end
  end

  #print SyllableMaker.guess_syllables(["Y", "UW1"])
  #print SyllableMaker.guess_syllables(["K", "AH0", "N", "T", "IH1", "N", "Y", "UW0"])

end
