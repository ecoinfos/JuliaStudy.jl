using JuliaStudy
using Documenter

DocMeta.setdocmeta!(JuliaStudy, :DocTestSetup, :(using JuliaStudy); recursive=true)

makedocs(;
    modules=[JuliaStudy],
    authors="Norel <norel.evoagile@gmail.com> and contributors",
    repo="https://github.com/ecoinfos/JuliaStudy.jl/blob/{commit}{path}#{line}",
    sitename="JuliaStudy.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ecoinfos.github.io/JuliaStudy.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ecoinfos/JuliaStudy.jl",
    devbranch="master",
)
