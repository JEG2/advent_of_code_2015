#!/usr/bin/env ruby -w

class Password
  def initialize(current)
    @current = current
  end

  attr_reader :current
  private     :current

  def valid?
    has_straight? && not_confusing? && has_pairs?
  end

  def next
    loop do
      @current = @current.succ
      break if valid?
    end
    self
  end

  def to_s
    current
  end

  private

  def has_straight?
    current.chars.each_cons(3).any? { |l, m, r| l.succ == m && m.succ == r }
  end

  def not_confusing?
    current.count("iol").zero?
  end

  def has_pairs?
    current.scan(/(.)\1/).uniq.size >= 2
  end
end

current = ARGV.shift or abort "USAGE:  #{$PROGRAM_NAME} CURRENT_PASSWORD"
password = Password.new(current)
puts password.next
