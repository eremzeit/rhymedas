module Rhymedas
  # Has methods to detect what kinds of rhymes two words have
  class Detector
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
    RHYME_TYPES = [:syllabic, :imperfect, :weak, :assonance, :consonance,
                    :semirhyme, :forced, :halfrhyme, :pararhyme, :alliteration]

    def self.rhyme_methods
      self.methods.select{|name| name.to_s.end_with?('rhyme?') }
    end

    def self.analyze(word1, word2)
      phon1, phon2 = Words.phonemes(word1), Words.phonemes(word2)

      syllables1 = SyllableMaker.guess_syllables(phon1)
      syllables2 = SyllableMaker.guess_syllables(phon2)
      Detector.normalize_stresses!(syllables1)
      Detector.normalize_stresses!(syllables2)

      RHYME_TYPES.each do |type|
        r = send("#{type}_rhyme?", phon1, phon2, syllables1, syllables2)
      end
      puts
    end

    def self.have_rhyme(word1, word2, type)
      phon1, phon2 = Words.phonemes(word1), Words.phonemes(word2)

      syllables1 = SyllableMaker.guess_syllables(phon1)
      syllables2 = SyllableMaker.guess_syllables(phon2)
      Detector.normalize_stresses!(syllables1)
      Detector.normalize_stresses!(syllables2)

      r = send("#{type}_rhyme?", phon1, phon2, syllables1, syllables2)
    end

    def self.perfect_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      _xperfect_rhyme_(:perfect, phonemes1, phonemes2, syllables1, syllables2)
    end

    def self.imperfect_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      _xperfect_rhyme_(:imperfect, phonemes1, phonemes2, syllables1, syllables2)
    end

    def self.weak_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      _xperfect_rhyme_(:weak, phonemes1, phonemes2, syllables1, syllables2)
    end

    def self.syllabic_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      s1, s2 = [syllables1, syllables2].map {|x| x.last.join('').gsub(/[0-9]/, '') }
      s1 == s2
    end

    def self.assonance_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      phonemes1,phonemes2 = [phonemes1, phonemes2].map do |x|
        x.map {|p| p.gsub(/[0-9]/, '')}.select {|p| p =~ /[AEIOU]/}
      end

      phonemes1.all? {|p| phonemes2.include?(p) } || phonemes2.all? {|p| phonemes1.include?(p) }
    end

    def self.alliteration_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      false
    end

    def self.forced_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      false
    end

    def self.halfrhyme_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      false
    end

    def self.semirhyme_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      false
    end

    def self.pararhyme_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      false
    end

    def self.consonance_rhyme?(phonemes1, phonemes2, syllables1, syllables2)
      phonemes1,phonemes2 = [phonemes1, phonemes2].map do |x|
        x.map {|p| p.gsub(/[0-9]/, '')}.select {|p| !(p =~ /[AEIOU]/)}
      end
      phonemes1.all? {|p| phonemes2.include?(p) } || phonemes2.all? {|p| phonemes1.include?(p) }
    end

    private
    def self._xperfect_rhyme_(type, phonemes1, phonemes2, syllables1, syllables2)
      syllables1 = remove_first_syllable(syllables1)
      syllables2 = remove_first_syllable(syllables2)

      shortest_length = [syllables1.length, syllables2.length].min
      i = 1

      r_s1 = []
      r_s2 = []
      while i <= shortest_length
        s1 = syllables1[-i]
        s2 = syllables2[-i]

        if s1.join('') != s2.join('')
          break
        end

        r_s1.push(s1)
        r_s2.push(s2)
        i += 1
      end
      return false if r_s1.empty?

      is_perfect = true
      is_imperfect = false
      (0...r_s1.length).each do |i|
        is_perfect = false if r_s1[i].stress != r_s2[i].stress
        is_imperfect = true if r_s1[i].stress == 1 || r_s2[i].stress == 1
      end

      case type
      when :perfect
        is_perfect
      when :imperfect
        is_imperfect
      when :weak
        true
      end
    end

    def self.remove_first_syllable(syllables)
      start = [1, syllables.length - 1].min
      syllables[(start...syllables.length)]
    end

    def self.normalize_stresses!(syllables)
      max = syllables.map{|s| s.stress}.max
      syllables.each do |s|
        if s.stress == max
          s.stress = 1
        else
          s.stress = 0
        end
      end
    end

    RHYME_TYPES.each do |type|
      instance_eval %Q"
        def have_#{type}_rhyme?(word1, word2)
          Detector.have_rhyme(word1, word2, :#{type})
        end
      "
    end
  end

end
