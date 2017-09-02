defmodule StreamElixir.Request do
	import Joken
	import HTTPotion
	import Poison

	alias StreamElixir.Base

	defstruct [method: :get, url: "", token: "", data: []]
	@type t :: %__MODULE__{}

	@doc """
		
		new_request/0
		Initializes a request

	"""

	def new_request, do: struct(%__MODULE__{})

	@doc """
			
		send/1
		Sends a request

	"""
	def send(req) do
		headers = ["Content-Type": "application/json", "Stream-Auth-Type": "jwt", "Authentication": req.token]
		path = req.url 
		method = req.method
		body = req.data

		request(method, path, headers: headers, body: body)
	end
	@doc """

	with_token/1 
	Creates and returns authentication token based on resource map provided using Joken.
	Uses the API Secret given by getstream.io to sign claims.

	Map is of the form %{resource: "*", action: "*", feed_id: "*"}
	A single '*' represents permissions for all options therefore the above map would grant 
	all permissions for every possible feed.

	Valid resources: activities, feed, follower
	Valid actions: read, write, delete
	Valid feeds: Any valid feed slug concatenated with a the user id of the feed instance

	Examples:

	%{resource: "feed", action: "read", feed_id: "user1"}
	Gives us read access to the feed of user with id 1

	%{resource: "activity", action:"write", feed_id:"usersean"}
	Gives us write access to the activities of user with id sean

	%{resource: "feed", action: "delete", feed_id: "user12"}
	Gives us delete access to the feed of user with id 12

	%{resource: "follower", action: "read", feed_id: "userjack"}
	Gives us read access to the followers of user with id jack

	"""

	def with_token(req, claims \\ %{resource: "*", action: "*", feed_id: "*"}) do
		jwt = 
			claims 
			|> token
			|> with_signer(hs256(Base.api_secret))
			|> sign
			|> get_compact
		%__MODULE__{req | token: jwt}
	end

	@doc """

	with_url/3
	Creates and returns a valid url for the given endpoint and parameters

	Endpoints are given as a list i.e. ["feed", "timeline_aggregated", "123"]
	Parameters are given as a map i.e. %{foreign_id: 1}

	Valid Endpoints:

	  Activities: activities/
	  Feed: feed/{feed_slug}/{user_id}/
	  Feed Detail: feed/{feed_slug}/{user_id}/{activity_id|foreign_id}/
	  Followers: feed/{feed_slug}/{user_id}/followers/
	  Following: feed/{feed_slug}/{user_id}/follows/
	  Following Detail: feed/{feed_slug}/{user_id}/following/{target}/

	Endpoints Variables: 

	  {feed_slug}: represents a feed in your list of feeds i.e. "users", "groups", "timeline"
	  {user_id}: represents the a reference to a user i.e. "sean" or "123"
	  {activity_id|foreign_id}: represents a reference to an activity or object i.e. "post12", "like1"
	  {target}: represents a target feed as {feed_slug}:{id} i.e. "user:12", "group:4"

	Valid Parameters:

	  Activities - 
	    - a JSON list of activities to update, up to 100

	"""

	def with_url(req, endpoint, params \\ %{}) do
		scheme = "https"
		query = URI.encode_query(Map.merge(params, %{api_key: Base.api_key}))
		path = Enum.join(endpoint ++ [""], "/")
		%__MODULE__{req | url: URI.to_string(%URI{scheme: scheme, host: Base.base_url, path: path, query: query})}
	end

	@doc """
		
		with_data/2

	"""

	def with_data(req, data) do
		body = 
			case encode(data) do
				{:ok, response} -> response
				{:error, response} -> :error
			end
		%__MODULE__{req | data: body}
	end
	@doc """

		with_method/2

	"""
	def with_method(req, method), do: %__MODULE__{req | method: method}
end