module Rhymedas
  class Words
    def self.phonemes(word)
      @phoneme_map ||= load_phoneme_map
    end

    def self.syllables(word)
      @syllable_map ||= load_syllable_map
    end

    private
    # Returns a hash of lists of phonemes in each word, keyed on the word
    def self.load_phoneme_map
      phoneme_map = {}
      _load do |word, line|
        phoneme_map[word] = line
      end
      phoneme_map
    end

    # Returns a hash of lists of syllables in each word, keyed on the word
    def self.load_syllable_map
      syllable_map = {}

      _load do |word, line|
        syllable_map[word] = guess_syllables(line)
      end
      syllable_map
    end

    # iteratively yields (word, phonemes)
    def self._load
      file = File.new("data/cmu-rhyming-dictionary.txt")
      starts_with_letter = /^[a-zA-Z]/
      has_parens = /\([0-9]\)/

      while(line = file.gets)
        if !starts_with_letter.match(line) || has_parens.match(line)
          next
        end
        line = line.split
        word = line.slice!(0)
        next if word == ''
        yield(word, line)
      end
    end
  end
end
