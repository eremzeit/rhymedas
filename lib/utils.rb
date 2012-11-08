require 'pry'

class Syllable < Array
  attr_accessor :stress

  def [](*args)
    super(*args).tap {|x| x.stress = self.stress }
  end

  def normalize
    _s = self.map do |syllable|
      syllable.gsub(/[0-9]/, '')
    end
    _s.join('/')
  end
end

# Returns a hash of lists of phonemes in each word, keyed on the word
def load_phoneme_map
  phoneme_map = {}
  _load do |word, line|
    phoneme_map[word] = line
  end
  phoneme_map
end

# Returns a hash of lists of syllables in each word, keyed on the word
def load_syllable_map
  syllable_map = {}

  _load do |word, line|
    syllable_map[word] = guess_syllables(line)
  end
  syllable_map
end

# iteratively yields (word, phonemes)
def _load
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

def starts_with_vowel?(str)
  ['a', 'e', 'i', 'o', 'u'].each do |x|
    return true if str.starts_with?(x)
  end
  false
end

# An implementation of the longest common subsequence algorithm
def lcs(a, b)
    lengths = Array.new(a.size+1) { Array.new(b.size+1) { 0 } }
    # row 0 and column 0 are initialized to 0 already
    a.each_with_index { |x, i|
        b.each_with_index { |y, j|
            if x == y
                lengths[i+1][j+1] = lengths[i][j] + 1
            else
                lengths[i+1][j+1] = \
                    [lengths[i+1][j], lengths[i][j+1]].max
            end
        }
    }
    # read the substring out from the matrix
    result = []
    x, y = a.size, b.size
    while x != 0 and y != 0
        if lengths[x][y] == lengths[x-1][y]
            x -= 1
        elsif lengths[x][y] == lengths[x][y-1]
            y -= 1
        else
            # assert a[x-1] == b[y-1]
            result << a[x-1]
            x -= 1
            y -= 1
        end
    end
    result.reverse
end

# Returns the requested number of syllables, from either the front
# or back of the list, depending what is passed for the type argument.
# If the requested number of syllables is greater than num_syllables,
# will simply return the entire list of syllables.
def get_outer_syllables(syllables, num_syllables, type)
  if type == :start
    syllables = syllables[(0...num_syllables)]
  elsif type == :end
    i = [syllables.length - num_syllables, 0].max
    syllables = syllables[i...syllables.length]
  end
end

def build_index(prunounce_map, num_syllables, type)
  index = {}
  prunounce_map.each_pair do |word, syllables|
    if syllables.length >= num_syllables
      syllables = get_outer_syllables(syllables, num_syllables, type)
      key_str = normalize_syllables(syllables)
      items = index[key_str] || []
      index[key_str] = items.push(word)
    end
  end

  index
end

# build a dictionary, keyed on words, mapped to a list of words that
# rhyme with that key word
def build_rhyme_dictionary
  word_map = load_syllable_map
  one_rhyme = build_index(word_map, 1, :end)
  two_rhyme = build_index(word_map, 2, :end)

  dict = {}
  WORDS.each do |word|
    puts word
    dict[word] = []
    syllables = get_outer_syllables(word_map[word], 1, :end)
    key = normalize_syllables(syllables)
    dict[word] += (one_rhyme[key] || [])

    syllables = get_outer_syllables(word_map[word], 2, :end)
    key = normalize_syllables(syllables)
    dict[word] += (two_rhyme[key] || [])
  end
  dict
end

def test_indices
  word_map = load_syllable_map
  one_rhyme = build_index(word_map, 1, :end)
  two_rhyme = build_index(word_map, 2, :end)
  one_allit = build_index(word_map, 1, :start)
  two_allit = build_index(word_map, 2, :start)
  require 'pry'; binding.pry
end

PHONEME_MAP = load_phoneme_map
