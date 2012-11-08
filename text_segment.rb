require 'pry'
require 'test/unit'
require './utils.rb'


class TextSegment
  attr_accessor :syllables, :accents, :phonemes

  def self.make_text_segment(natural_text)
    TextSegment.new(natural_text, TextSegment.preprocess_text(natural_text))
  end

  def self.preprocess_text(natural_text)
    natural_text = natural_text.upcase.gsub(/[^A-Z ]/, '').gsub(' ', ' | ')
    words = natural_text.split(' ')

    phonemes = []
    words.each do |word|
      _p = PHONEME_MAP[word]
      if word == '|' || !_p.nil?
        phonemes += _p || [word]
      else
        puts "Ignoring #{word}"
      end
    end
    phonemes
  end

  def initialize(text, phonemes)
    @text = text
    @syllables = guess_syllables(phonemes)
    @accents = read_accents(phonemes)
    @phonemes = strip_accents(phonemes).select {|p| p != '|' }
  end

  def words
    @text.split(' ')
  end

  def syllables_longest_common_substring(text_segment)
    syllables1 = normalize_syllables
    syllables2 = text_segment.normalize_syllables

    lcs(syllables1, syllables2)
  end

  def phonemes_longest_common_substring(text_segment)
    lcs(phonemes, text_segment.phonemes)
  end

  def normalize_syllables
    _normalized_syllables = []
    @syllables.each do |syllable|
      _normalized_syllables << syllable.join('')
    end
    _normalized_syllables
  end

  def only_consonant_phonemes
    _phonemes = []
    @phonemes.each do |phoneme|
      if not starts_with_vowel(phoneme)
        _phonemes << phoneme
      end
    end
    _phonemes
  end

  def only_vowel_phonemes
    _phonemes = []
    @phonemes.each do |phoneme|
      if starts_with_vowel(phoneme)
        _phonemes << phoneme
      end
    end
    _phonemes
  end

  private
  def read_accents(phonemes)
    accents = []
    phonemes.each do |phoneme|
       r = phoneme.gsub(/[^0-9]/, '')
       next if r.empty?
       accents << r
    end
    accents
  end

  def strip_accents(phonemes)
    _phonemes = []
    phonemes.each do |phoneme|
       r = phoneme.gsub(/[0-9]/, '')
       _phonemes << r
    end
    _phonemes
  end

  def guess_syllables(phonemes)
    #break up phonemes into groups by the included accents
    phonemes = phonemes.dup
    syllables = []
    until phonemes.empty?
      phons = []
      while true
        if (/[0-9|]$/.match(phonemes.slice(0)) && !phons.empty?) || phonemes.empty?
          break
        end
        phon = phonemes.slice!(0).gsub(/[0-9|]/, '')
        if not phon.empty?
          phons << phon
        end
      end

      syllables << phons
    end
    syllables
  end
end


