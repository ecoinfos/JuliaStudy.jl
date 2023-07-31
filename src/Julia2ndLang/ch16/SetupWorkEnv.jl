using JuliaStudy
using Pkg

PROJECT_ROOT = pkgdir(JuliaStudy)
CURRENT_SRC = "src/Julia2ndLang/ch16"

JOB_DIR = joinpath(PROJECT_ROOT, CURRENT_SRC, "job")
HOBBY_DIR = joinpath(PROJECT_ROOT, CURRENT_SRC, "hobby")

Pkg.mkdir(JOB_DIR)
Pkg.mkdir(HOBBY_DIR)

Pkg.activate(JOB_DIR)
Pkg.add(name="CairoMakie", version="0.5.10")
Pkg.add("ElectronDisplay")
Pkg.status()

Pkg.activate(HOBBY_DIR)
Pkg.add("CairoMakie")
Pkg.add("ElectronDisplay")
run(`cat $(HOBBY_DIR)/Project.toml`)
Pkg.rm("CairoMakie")
# uuid do not contain version info.
Pkg.add(name="CairoMakie", uuid="13f3f980-e62b-5c42-98c6-ff1f3baf88f0")
Pkg.add("Dates")
Pkg.status()
Pkg.rm("Dates")
Pkg.status()

pwd()
cd("src/Julia2ndLang/ch16/hobby")
pwd()
Pkg.generate("ToyGeometry")
run(`cat ToyGeometry/Project.toml`)
Pkg.activate("ToyGeometry")
Pkg.add("Dates")
Pkg.add("Base64")
Pkg.status()
run(`cat ToyGeometry/Project.toml`)
run(`cat ToyGeometry/Manifest.toml`)

Pkg.activate(".")   # hobby
Pkg.add("OhMyREPL")
Pkg.add("Revise")
Pkg.status()
# using ToyGeometry  # should have error
Pkg.develop(PackageSpec(path = "./ToyGeometry"))
Pkg.status()

using ToyGeometry
ToyGeometry.sphere_volume(4)
ToyGeometry.sine(π/2)
sin(π/2)
sine(π/2)


