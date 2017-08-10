defmodule StreamElixir.Activity do
		
	@enforce_keys [:actor, :verb, :object]
	defstruct [:actor, :verb, :object, :target, :time, :to, :foreign_id]

end