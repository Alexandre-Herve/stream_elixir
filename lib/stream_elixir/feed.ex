defmodule StreamElixir.Feed do
		
	@enforce_keys [:slug, :id, :feed]
	defstruct [:slug, :id, :feed]
	@type t :: %__MODULE__{slug: String, id: String, feed: List}

	alias StreamElixir.Request

	@doc """
		get/2
		Returns the feed result for given slug and id wrapped in a Feed struct
	"""
	def get(slug, id) do
		
	end


	defp endpoint(slug, id), do: ["feed", slug, id]
end