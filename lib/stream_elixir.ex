defmodule StreamElixir do
  import Joken
  import Poison
  import HTTPotion

  @doc """
    
    create_jwt/1 
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

  def create_jwt(claims \\ %{resource: "*", action: "*", feed_id: "*"}) do
    claims 
    |> token
    |> with_signer(hs256(api_secret))
    |> sign
    |> get_compact
  end

  @doc """
    
    create_url/2
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

  def create_url(endpoint, params \\ %{}) do
    scheme = "https"
    query = URI.encode_query(Map.merge(params, %{api_key: api_key}))
    path = Enum.join(endpoint ++ [""], "/")
    URI.to_string(%URI{scheme: scheme, host: base_url, path: path, query: query})
  end

  @doc """
    base_url/0, api_key/0, api_secret/0, app_id/0
    Returns values for the corresponding config variables set in whatever configuration environment we're
    working in
  """
  defp base_url, do: Application.get_env(:stream_elixir, :BASE_URL)
  defp api_key, do: Application.get_env(:stream_elixir, :API_KEY)
  defp api_secret, do: Application.get_env(:stream_elixir, :API_SECRET)
  defp app_id, do: Application.get_env(:stream_elixir, :APP_ID)

end
