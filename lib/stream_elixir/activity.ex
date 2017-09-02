defmodule StreamElixir.Activity do
		
	defstruct [:actor, :verb, :object, :target, :time, :to, :foreign_id, :custom_fields]
	@type t :: %__MODULE__{actor: Struct, verb: String, object: String, target: List, time: String, to: List, foreign_id: List, custom_fields: Struct}

	@doc """
			
		create/1, create/0
		Initializes a new struct into an activity struct with provided feed (actor) OR with no actor given

	"""
	def create(actor), do: %__MODULE__{actor: actor}
	def create, do: %__MODULE__{}


	@doc """
			
		with_verb/2, with_object/2, with_target/2, with_time/2, with_foreign_id/2, with_custom_fields/2, to/2
		Helpers that wrap the given field into the activity struct

	"""
	def with_actor(activity, actor), do: %__MODULE__{activity | actor: actor}
	def with_verb(activity, verb), do: %__MODULE__{activity | verb: verb}
	def with_object(activity, object), do: %__MODULE__{activity | object: object}
	def with_target(activity, target), do: %__MODULE__{activity | target: target}
	def with_time(activity, time), do: %__MODULE__{activity | time: time}
	def with_foreign_id(activity, foreign_id), do: %__MODULE__{activity | foreign_id: foreign_id}
	def with_custom_fields(activity, custom_fields), do: %__MODULE__{activity | custom_fields: custom_fields}
	def to(activity, to), do: %__MODULE__{activity | to: to}
end