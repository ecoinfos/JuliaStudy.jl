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





