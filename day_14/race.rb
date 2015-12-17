#!/usr/bin/env ruby -w

class Race
  RACER_FORMAT = %r{
    \A (\w+) \b .+
    \b fly \s+ (\d+) \s+ km/s \s+ for \s+ (\d+) \s+ seconds \b .+
    \b rest \s+ for \s+ (\d+) \s+ seconds. \Z
  }x

  def initialize
    @reindeer = { }
  end

  attr_reader :reindeer
  private     :reindeer

  def add(racer)
    fail "Bad racer:  #{racer}" unless racer =~ RACER_FORMAT

    reindeer[$1] = {flying: {speed: $2.to_i, duration: $3.to_i}, rest: $4.to_i}
  end

  def run(seconds)
    Hash[reindeer.map { |name, stats| [name, distance(stats, seconds)] }]
  end

  def winner(*args)
    run(*args).values.max
  end

  private

  def distance(stats, seconds)
    travelled = 0
    time = 0

    until time == seconds
      flying_time = [stats[:flying][:duration], seconds - time].min
      travelled += stats[:flying][:speed] * flying_time
      time += flying_time + [stats[:rest], seconds - (time + flying_time)].min
    end

    travelled
  end
end

race = Race.new
ARGF.each do |racer|
  race.add(racer)
end
p race.winner(2_503)
