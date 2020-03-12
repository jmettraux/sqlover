
require 'time'

fn = nil
fi = nil
max = 1.0

ARGV.each do |a|
  if a.match(/^\d+(\.\d+)?$/)
    max = a.to_f
  else
    fn = a
  end
end

fi = fn ? File.open(fn, 'r') : STDIN

#
# gather data

t0 = nil
t9 = nil
counts = %w[ select insert update delete begin commit ]
  .inject({}) { |h, m|
    h[m.to_sym] = { count: 0, min: 1.0, max: 0.0, maxes: 0 }
    h }
worst = [ max, '' ]

while line = (fi.readline rescue nil)

  if mt = line.match(/^(\d+-[A-Za-z]+-\d{4} \d{2}:\d{2}:\d{2}\.\d+) /)

    t = Time.parse(mt[1])

    t0 = t0 || t
    t9 = t
  end

  m0 = line
    .match(/ \((\d+\.\d+)s\) (SELECT|INSERT INTO|UPDATE|DELETE|BEGIN|COMMIT) /)
  m1 =
    m0 ? nil : line.match(/PoolTimeout/)

  if m0

    d = m0[1].to_f
    k = m0[2].split(' ').first.downcase.to_sym
    maxe = d >= max

    puts line if maxe

    count = counts[k]
      #
    count[:count] += 1
    count[:maxes] += 1 if maxe
    count[:min] = [ count[:min], d ].min
    count[:max] = [ count[:max], d ].max

    worst = [ d, line ] if d > worst.first

  elsif m1

    puts "+++TIMEOUT+++ " + line

  else

    # do nothing
  end
end

fi.close rescue nil

#
# stats

counts.values.each do |v|

  v[:maxp] = "#{v[:maxes].to_f / v[:count].to_f * 100}%" if v[:count] > 0
end

#
# output

puts
puts "-" * 80
puts
puts "t0: #{t0}"
puts "t9: #{t9}"
puts
pp counts
puts
puts worst[0]
puts worst[1]
puts

