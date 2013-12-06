module Rhymedas
  class SyllableMaker
    DESCENDING_PHONEMES = [
              ['C','T'],
              ['L','T'],
              ['L','D'],
              #['N','T'],
              ['S','T'],
              ['F','T'],
            ]

    # Three phases to a syllable:
    #   1) ascending phonemes
    #   2) vowel phoneme
    #   3) descending phonemes
    def self.guess_syllables(phonemes)
      #break up phonemes into groups by the included accents
      phonemes = phonemes.dup
      syllables = []
      while not phonemes.empty?
        seen_vowel = false
        syllable = Syllable.new
        while true
          break if phonemes.empty?

          is_vowel = is_vowel_phoneme(phonemes[0])
          break if is_vowel && seen_vowel

          p = phonemes.slice!(0)
          if is_vowel
            syllable.stress = Integer(p[is_vowel])
            seen_vowel = true
            p = p.gsub(/[0-9]/, '')
          end
          syllable << p

          if !is_vowel && seen_vowel
            if is_descending_phonemes(p, phonemes.slice(0))
              p = phonemes.slice!(0)
              syllable << p
            end
            break
          end
          if not has_any_more_vowels(phonemes)
            while not phonemes.empty?
              syllable << phonemes.slice!(0)
            end
          end
        end

        syllables << syllable
      end
      syllables
    end

    def self.is_vowel_phoneme(phon)
      phon =~ /[0-9]/
    end

    def self.is_descending_phonemes(c1, c2)
      DESCENDING_PHONEMES.each do |pair|
        return true if c1 == pair[0] && c2 == pair[1]
      end
      false
    end

    #returns whether the list of phonemes have any more vowel phonemes in it
    def self.has_any_more_vowels(phonemes)
      phonemes.any? {|p| is_vowel_phoneme(p) }
    end
  end
end
