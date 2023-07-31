using ElectronDisplay
using CairoMakie

xs = 1:0.1:10
ys1 = map(sin, xs)
ys2 = map(cos, xs)

scatter(xs, ys1)
scatter!(xs, ys2)
current_figure()

lines(xs, ys1, linewidth=5)
lines!(xs, ys2, linewidth=5)
current_figure()


