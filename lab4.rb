require 'gruff'
require 'terminal-table'
require 'pry'

VARIANT = 14
t_obs = 20.to_f / 100
lambd = 0.01
n_zavd = 8
N = 10 # number of iterations
current = 0
p_n_obszd = 0.941
p_t_obszd = 0.595
p_l_obszd = 0.952

p_l_obszd_array = Array.new(N, p_l_obszd)
p_obs_array = []
lambd_array = []

headings = %w[lambda P_obs P_obszd]
rows = []
while current < N do
  lambd_array << lambd
  alpha = t_obs.to_f / lambd
  sum = 0
  for k in (0..n_zavd) do
    sum += (alpha**k.to_f / Math.gamma(k+1))
  end
  p_o = 1.to_f / sum
  p_n = alpha**n_zavd.to_f / Math.gamma(n_zavd+1) * p_o
  p_obs = 1 - p_n
  p_obs_array << p_obs
  n_k = alpha * p_obs
  k_z = n_k.to_f / n_zavd
  sum_2 = 0
  for k in (0..n_zavd-1) do
    sum_2 += alpha**k * (n_zavd - k).to_f / Math.gamma(k+1) * p_o
  end
  n_o = sum_2 * p_o
  k_p = n_o.to_f / n_zavd

  # puts "#{lambd}\t#{alpha} \t#{p_o}\t#{p_n}\t#{p_obs}\t#{n_k}\t#{k_z}\t#{n_o}\t#{k_p}\t#{n_zavd}"
  rows << [lambd, p_obs, p_l_obszd]
  # rows << [lambd, alpha, p_o, p_n, p_obs, n_k, k_z, n_o, k_p, n_zavd]
  lambd += 0.005
  current += 1
end

puts Terminal::Table.new title: "P_obszd = #{p_l_obszd}; n = #{n_zavd}, t_obs = #{t_obs} VARIANT #{VARIANT}", headings: headings, rows: rows

g = Gruff::Line.new
g.title = "Графік залежності P_обс від lambda"
g.data 'Р_обс', p_obs_array
g.data 'Р_обсзв', p_l_obszd_array
# g.data 'K_з', k_z_array
g.labels = (1..n_zavd).to_a.to_h { |n| [n-1, lambd_array[n-1].round(3)] }
g.write("img/plot4.png")