def fibs(n)
  a = 1
  b = 0
  puts 1
  (n - 1).times do
    t = a + b 
    puts t
    b = a
    a = t
  end
end

def fibs_rec(n)
  if n <= 0 
    0
  elsif n == 1
    1
  else
    return fibs_rec(n-1) + fibs_rec(n-2)
  end
end

puts fibs_rec(13)