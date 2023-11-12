module MementoPattern

using Dates

struct Post
  title::String
  content::String
end

struct Blog
  author::String
  posts::Vector{Post}
  date_created::DateTime
end

function Blog(author::String, post::Post)
  return Blog(author, [post], now())
end

version_count(blog::Blog) = length(blog.posts)
current_post(blog::Blog) = blog.posts[end]

function update!(blog::Blog; title = nothing, content = nothing)
  post = current_post(blog)
  new_post = Post(something(title, post.title),
    something(content, post.content))
  push!(blog.posts, new_post)
  return new_post
end

function undo!(blog::Blog)
  if version_count(blog) > 1
    pop!(blog.posts)
    return current_post(blog)
  else
    error("Cannot undo... no more previous history.")
  end
end

function test()
  blog = Blog("Tom", Post("Why is Julia os great?", "Blah blah."))
  update!(blog, content = "The reason are...")

  println("Number of versions: ", version_count(blog))
  println("Currnet post")
  println(current_post(blog))
  println("Undo #1")
  undo!(blog)
  println(current_post(blog))

  println("Undo #2") # expect error
  undo!(blog)
  println(current_post(blog))
end


end
