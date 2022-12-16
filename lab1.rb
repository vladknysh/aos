require 'gruff'
require 'terminal-table'
require 'pry'

VARIANT = 14
t_obs = 20.to_f / 100
lambd = 55**-1
# N = 8
N = 13 # optimal 11 for k_z
p_n_obszd = 0.941
p_t_obszd = 0.595
p_l_obszd = 0.952

p_n_obszd_array = Array.new(N, p_n_obszd)
p_obs_array = []
k_z_array = []

alpha = t_obs.to_f / lambd

headings = %w[lambd alpha p_o p_n p_obs n_k k_z n_o k_p n_zavd]
rows = []
# puts "lambd\talpha\tp_o\tp_n\tp_obs\tn_k\tk_z\tn_o\tk_p\tn_zavd"
for n_zavd in (1..N) do
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
  k_z_array << k_z
  sum_2 = 0
  for k in (0..n_zavd-1) do
    sum_2 += alpha**k * (n_zavd - k).to_f / Math.gamma(k+1) * p_o
  end
  n_o = sum_2 * p_o
  k_p = n_o.to_f / n_zavd

  # puts "#{lambd}\t#{alpha} \t#{p_o}\t#{p_n}\t#{p_obs}\t#{n_k}\t#{k_z}\t#{n_o}\t#{k_p}\t#{n_zavd}"
  rows << [lambd, alpha.round, p_o.round(7), p_n.round(3), p_obs.round(3), n_k.round(3), k_z.round(3), n_o.round(7), k_p.round(7), n_zavd]
  # rows << [lambd, alpha, p_o, p_n, p_obs, n_k, k_z, n_o, k_p, n_zavd]
end

puts Terminal::Table.new title: "n = #{N}, t_obs = #{t_obs}, VARIANT #{VARIANT}", headings: headings, rows: rows

g = Gruff::Line.new
g.title = "Графік залежності P(обс) від кількості процесорів"
g.data 'Р_обс', p_obs_array
# g.data 'Р_обсзв', p_n_obszd_array
g.data 'K_з', k_z_array
g.labels = (1..N).to_a.to_h { |n| [n-1, n] }
# g.write("img/plot1.png")
g.write("img/plot1.1.png")