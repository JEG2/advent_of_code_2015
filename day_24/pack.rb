#!/usr/bin/env ruby -w

# packages = [1, 2, 3, 4, 5, 7, 8, 9, 10, 11]
packages = [ ]
ARGF.each do |package|
  packages << package.to_i
end
group_sum = packages.inject(:+) / 3

best_so_far = Float::INFINITY
1.upto(packages.size - 2) do |group_1_size|
  packages.combination(group_1_size).each do |group_1|
    next unless group_1.inject(:+) == group_sum
    quantum_entanglement = group_1.inject(:*)
    next unless quantum_entanglement < best_so_far
    remaining_packages = packages - group_1
    grouping_exists = (1..(remaining_packages.size - 1)).any? { |group_2_size|
      remaining_packages.combination(group_2_size).any? { |group_2|
        group_3 = remaining_packages - group_2
        group_sum == group_2.inject(:+) && group_sum == group_3.inject(:+)
      }
    }
    if grouping_exists
      best_so_far = quantum_entanglement
    end
  end
  break if best_so_far < Float::INFINITY
end

p best_so_far
