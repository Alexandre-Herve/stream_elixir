defmodule StreamElixir.Base do

	@doc """
		
		now/0
		Returns the current UTC time string

	"""
	def now, do: DateTime.to_string(DateTime.utc_now)

	@doc """
	base_url/0, api_key/0, api_secret/0, app_id/0
	Returns values for the corresponding config variables set in whatever configuration environment we're
	working in
	"""
	def base_url, do: Application.get_env(:stream_elixir, :BASE_URL)
	def api_key, do: Application.get_env(:stream_elixir, :API_KEY)
	def api_secret, do: Application.get_env(:stream_elixir, :API_SECRET)
	def app_id, do: Application.get_env(:stream_elixir, :APP_ID)


end