require 'pry'
require 'test/unit'
require './utils.rb'
require './text_segment.rb'


lines = [
          [
            'When I consider how my light is spent',
            'Lodged with me useless, though my soul more bent'
          ],

          [
            'Ere half my days, in this dark world and wide',
            'And that one talent which is death to hide'
          ],
          [
            'My true account, lest he returning chide;',
            'Doth God exact day-labor, light denied?'
          ]
      ]

ts1 = TextSegment.make_text_segment(lines[1][0])
ts2 = TextSegment.make_text_segment(lines[1][1])

ts1.syllables_longest_common_substring(ts2)
require 'pry'; binding.pry

