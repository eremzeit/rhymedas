module Rhymedas
  class Words
    DEFAULT_PHONEME_FILEPATH = "data/cmu-rhyming-dictionary.txt"

    def self.phonemes(word)
      init if @phoneme_map.nil?
      @phoneme_map[word.upcase].tap do |phonemes|
        raise "Word not found: #{word}" if phonemes.nil?
      end
    end

    def self.syllables(word)
      init if @syllable_map.nil?
      @syllable_map ||= load_syllable_map
      @syllable_map[word.upcase].tap do |syllables|
        raise "Word not found: #{word}" if syllables.nil?
      end
    end

    def self.init(phoneme_filepath = nil)
      @phoneme_map = {}
      @syllable_map = {}
      path = phoneme_filepath || DEFAULT_PHONEME_FILEPATH

      _load(path) do |word, line|
        @phoneme_map[word] = line
        @syllable_map[word] = SyllableMaker.guess_syllables(line)
      end
    end

    def self.count
      @phoneme_map.keys.length
    end
    private

    # iteratively yields (word, phonemes)
    def self._load(filepath)
      file = File.new(filepath)
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
