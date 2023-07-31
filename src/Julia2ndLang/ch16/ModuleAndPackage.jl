module Cylinder
volume(r, h) = π * r^2 * h
end

module Cone
volume(r, h) = π * r^2 * h / 3
end

Cylinder.volume(2.5, 3)
Cone.volume(2.5, 3)
