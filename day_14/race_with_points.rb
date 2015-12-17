#!/usr/bin/env ruby -w

class Reindeer
  def initialize(name: , speed: , duration: , rest: )
    @name = name
    @speed = speed
    @duration = duration
    @rest = rest
    @state = :fly
    @time_in_state = 0
    @distance = 0
    @points = 0
  end

  attr_reader :name, :distance, :points

  attr_reader :speed, :duration, :rest, :state
  private     :speed, :duration, :rest, :state

  def advance
    @time_in_state += 1
    send("#{state}_for_a_second")
  end

  def score
    @points += 1
  end

  private

  def fly_for_a_second
    @distance += speed
    transition(duration, :rest)
  end

  def rest_for_a_second
    transition(rest, :fly)
  end

  def transition(limit, to)
    if @time_in_state == limit
      @state = to
      @time_in_state = 0
    end
  end
end

class Race
  RACER_FORMAT = %r{
    \A (\w+) \b .+
    \b fly \s+ (\d+) \s+ km/s \s+ for \s+ (\d+) \s+ seconds \b .+
    \b rest \s+ for \s+ (\d+) \s+ seconds. \Z
  }x

  def initialize
    @reindeer = [ ]
  end

  attr_reader :reindeer
  private     :reindeer

  def add(racer)
    fail "Bad racer:  #{racer}" unless racer =~ RACER_FORMAT

    reindeer << Reindeer.new(
      name: $1,
      speed: $2.to_i,
      duration: $3.to_i,
      rest: $4.to_i
    )
  end

  def run(seconds)
    seconds.times do
      reindeer.each(&:advance)
      lead = reindeer.map(&:distance).max
      reindeer.each do |racer|
        racer.score if racer.distance == lead
      end
    end
  end

  def winner
    reindeer.map(&:points).max
  end
end

race = Race.new
ARGF.each do |racer|
  race.add(racer)
end
race.run(2_503)
p race.winner
