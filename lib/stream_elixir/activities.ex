defmodule StreamElixir.Activities do
	
	import StreamElixir.Request
	@doc """
		
		add/1

	"""

	def add(activity) do
		actor = Enum.join([activity.actor.slug, activity.actor.id], ":")

	end

	@doc """
		
		update/2

	"""
	
	def update(old, new) do
		old
	end

	@doc """
		
		delete/1

	"""

	def delete(activity) do 
		activity
	end

	@doc """
		
		update/1

	"""

	defp endpoint, do: ["activities"]

	@doc false 
	def flatten(struct) do
		Enum.flat_map(struct, fn f -> f end)
	end

end