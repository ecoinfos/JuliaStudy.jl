module HackerNewsAnalysis

using HTTP
using JSON3
using Statistics: mean
using Dates: now
using Formatting: printfmtln

function fetch_top_stories()
  url = "https://hacker-news.firebaseio.com/v0/topstories.json"
  response = HTTP.request("GET", url)
  return JSON3.read(String(response.body))
end

struct Story
  by::String
  descendants::Union{Nothing, Int}
  id::Int
  kids::Union{Nothing, Vector{Int}}
  score::Int
  time::Int
  title::String
  # type::String
  url::Union{Nothing, String}
end

# Construct a Story from a Dict (or Dict-compatable) object 
function Story(obj)
  value = (x) -> get(obj, x, nothing)
  return Story(obj[:by],
    value(:descendants),
    obj[:id],
    value(:kids),
    obj[:score],
    obj[:time],
    obj[:title],
    # obj[:type],
    value(:url))
end

function fetch_story(id)
  url = "https://hacker-news.firebaseio.com/v0/item/$(id).json"
  response = HTTP.request("GET", url)
  return Story(JSON3.read(String(response.body)))
end

function average_score(n = 10)
  story_ids = fetch_top_stories()
  println(now(), " Found ", length(story_ids), " stories")

  top_stories = [fetch_story(id) for id in story_ids[1:min(n, end)]]
  println(now(), " Fetched ", n, " story details")

  avg_top_scores = mean(s.score for s in top_stories)
  println(now(), " Average score = ", avg_top_scores)

  return avg_top_scores
end

top_story_id = first ∘ fetch_top_stories

top_story = fetch_story ∘ first ∘ fetch_top_stories

title(s::Story) = s.title
top_story_title = title ∘ fetch_story ∘ first ∘ fetch_top_stories

function average_score2(n = 10)
  fetch_top_stories() |> take(n) |> fetch_story_details |>
  calculate_average_score
end

take(n::Int) = xs -> xs[1:min(n, end)]
fetch_story_details(ids::Vector{Int}) = fetch_story.(ids)
function calculate_average_score(stories::Vector{Story})
  mean(s.score for s in stories)
end

logx(fmt::AbstractString, f::Function = identity) = x -> begin
  let y = f(x)
    print(now(), " ")
    printfmtln(fmt, y)
  end
  return x
end

function average_score3(n = 10)
  fetch_top_stories() |>
  logx("Number of top stories = {}", length) |>
  take(n) |>
  logx("Limited number of stories = $n") |>
  fetch_story_details |>
  logx("Fetch story details") |>
  calculate_average_score |>
  logx("Average score = {}")
end

hotness(score) = score > 100 ? Val(:high) : Val(:low)

celebrate(v::Val{:high}) = logx("Woohoo! Lots of hot topics!")(v)
celebrate(v::Val{:low}) = logx("It's just a normal day...")(v)

check_hotness(n = 10) = average_score3(n) |> hotness |> celebrate

add1v(xs) = [x + 1 for x in xs]
mul2v(xs) = [2x for x in xs]

add1mul2v(xs) = xs |> add1v |> mul2v

add1(x) = x + 1
mul2(x) = 2x

add1mul2(xs) = xs .|> add1 .|> mul2

end
