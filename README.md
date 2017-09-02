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
	|> Feed.get

# Delete an activity by foreign_id
sean
|> Activity.with_foreign_id('picture:10')
|> Activities.delete
```

## Feeds
stream_elixir provides one module for working with feeds.
```elixir
StreamElixir.Feed 		# Main methods for creating, deleting, updating, and following feeds.
```




## Activities
stream_elixir provides two modules for working with activities.
```elixir
StreamElixir.Activity 		# Defines Activity struct and provides helper functions for creating Activity structs
StreamElixir.Activities 	# Main methods for inserting, removing, and updating activities
```

**StreamElixir.Activity**  
An activity must have three basic properties: an actor, a verb, and an object. These three properties are the MINIMUM amount of information needed to create an activity and add it to a feed. Below shows the creation of an activity with the provided helper method as well as the struct equivalent.

```elixir
alias StreamElixir.Activity

sean = Feed.get('user', 'sean')

activity =	
	sean
	|> Activity.with_verb('add') 				# Add verb 'add'
	|> Activity.with_object('picture:10') 			# Add object 'picture:10'
	|> Activity.with_target('board:10') 			# Add target 'board:10'
	|> Activity.with_time(Activity.now) 			# Add time current UTC time string
	|> Activity.with_foreign_id('picture:10') 		# Add foreign id 'picture:10'
	|> Activity.with_custom_fields(%{message: "hello"}) 	# Add custom field 'message' with value "hello"
	|> Activity.to(['notification:jessica']) 		# Add target to jessica's notification feed (see "Targeting")
	|> Activity.create 					# Initialize activity with above credentials

# The above pipeline is equivalent to the following Activity struct
activity =
	%Activity{
		actor: sean,
		verb: 'add',
		object: 'picture:10',
		target: 'board:10',
		time: Base.now,
		foreign_id: 'picture:10',
		custom_fields: %{message: "hello"},
		to: ['notification:jessica']
	}
```

**StreamElixir.Activities**  
The activities module provides methods that will communicate with the API. These methods are:
* *add/1*
* *update/1*
* *delete/1*

*Note: Methods for retrieving activities are provided in the Feed module.*
