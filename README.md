# StreamElixir

**A [getstream.io](http://getstream.io) client for the elixir language.**

## Installation

If the package can be installed by adding `stream_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stream_elixir, "~> 0.1.0"}
  ]
end
```

## Getting Started

The quickstart below shows you how to build a scalable social network. It highlights the most common API calls.

```elixir
alias StreamElixir.Feed
alias StreamElixir.Activity

# Get feed with slug user and id sean (returns a %Feed{} struct)
sean = Feed.get('user', 'sean')

# Adds an activity with sean as the actor
sean
|> Activity.create
|> Activity.with_verb('add')
|> Activity.with_object('picture:10')
|> Activity.with_foreign_id('picture:10')
|> Activity.with_custom_fields(%{message: 'This bird is absolutely beautiful. Glad it\'s recovering from a damaged wing.'})
|> Activities.add

# Activities can also be created with and Activity struct.
add_picture = %Activity{actor: sean, verb: 'add', object: 'picture:10', foreign_id: 'picture:10', custom_fields: %{message: 'Great picture!'}}
sean
|> Activities.add(add_picture)

# Get Jack's timeline and follow Sean's feed
jack = 
	Feed.get('timeline', 'jack')
	|> Feed.follow(sean)


# Read Jack's timeline limiting results to 10 
timeline = 
	jack
	|> Feed.with_limit(10)

# Read the next page of Jack's timeline, after uses default id filtering
next =	
	jack
	|> Feed.with_limit(10)
	|> Feed.after(timeline)

# Delete an activity by foreign_id
sean
|> Activity.with_foreign_id('picture:10')
|> Activities.delete
```

