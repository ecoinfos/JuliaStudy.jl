using ToyGeometry, CairoMakie, ElectronDisplay

ToyGeometry.sphere_volume(4)
ToyGeometry.sine(π/2)
sine(π/2)
sin(π/2)
cosine(π)
cos(π)
ToyGeometry.fac(3)
# fac(3)    # should have access error.

xs = 0:0.1:2π
ys1 = map(sin, xs)
ys2 = map(sine, xs)
lines(xs, ys1, linewidth=5)
lines!(xs, ys2, linewidth=5)
current_figure()

