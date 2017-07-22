require 'wrapper_based'

module SoftSinging
  def sing(lyrics)
    puts "#{name}: #{lyrics.to_s.downcase}"
  end
end

module LoudSinging
  def sing(lyrics)
    puts "#{name}: #{lyrics.to_s.upcase}!"
  end
end

module NormalSinging
  def sing(lyrics)
    puts "#{name}: #{lyrics}"
  end
end

class Trio < DCI::Context(normaly: NormalSinging, softly: SoftSinging, loudly: LoudSinging)
  def initialize(singing = nil, normaly: singing, softly: singing, loudly: singing)
    super(normaly: normaly, softly: softly, loudly: loudly)
  end

  def perform(song)
    song.each_slice(3).each do |first, second, third|
      softly.sing(first)
      loudly.sing(second)
      normaly.sing(third)
    end
  end
end

class Duet < DCI::Context(female: SoftSinging, male: LoudSinging)
  def initialize(singing = nil, female: singing, male: singing)
    super(female: female, male: male)
  end

  def perform(song)
    song.each_slice(2).each do |first, last|
      female.sing(first)
      male.sing(last)
    end
  end
end

Singer = Struct.new(:name)
singer = Singer['Justin']
artist = Trio.new(singer)

words = ["Na", "Hey", "Baby", "Oh", "Ooh", "You"]

pop_song = words.permutation.flat_map(&:to_a).shuffle.first(20)
artist.perform pop_song