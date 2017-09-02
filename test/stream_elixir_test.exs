defmodule StreamElixirTest do
  use ExUnit.Case

  alias StreamElixir.Request
  alias StreamElixir.Activity 
  alias StreamElixir.Feed 

  doctest StreamElixir


 	test "creates correct god token" do
 		assert StreamElixir.Request.with_token(%Request{}).token == "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3Rpb24iOiIqIiwiZmVlZF9pZCI6IioiLCJyZXNvdXJjZSI6IioifQ.VMFhIAnimoxSR7BXdvk_44JGXZazJx0hNldhK_LAjRs"
 	end

 	test "with_url/3 generates correct endpoint with no parameters" do
 		assert StreamElixir.Request.with_url(%Request{}, ["activities"]).url == "https://us-east-api.getstream.io/api/v1.0/activities/?api_key=fd673z8568xs"
 	end

 	test "with_url/3 generates correct endpoint with 1 parameter" do
 		assert StreamElixir.Request.with_url(%Request{}, ["feed", "user", "123", "followers"], %{offset: 10}).url == "https://us-east-api.getstream.io/api/v1.0/feed/user/123/followers/?api_key=fd673z8568xs&offset=10"
 	end

 	test "with_url/3 generates correct endpoint with multiple parameters" do
 		assert StreamElixir.Request.with_url(%Request{}, ["feed", "timeline_aggregated", "123"], %{limit: 10, offset: 10}).url == "https://us-east-api.getstream.io/api/v1.0/feed/timeline_aggregated/123/?api_key=fd673z8568xs&limit=10&offset=10"
 	end

 	test "with_method/2 generates correct method" do
 		assert StreamElixir.Request.with_method(%Request{}, :post).method == :post
 	end

 	test "with_data/2 generates correct dataset" do
 		assert StreamElixir.Request.with_data(%Request{}, [%{feed: "user", name: "sean"}]).data == "[{\"name\":\"sean\",\"feed\":\"user\"}]"
 	end

 	test "pipeline generates proper request" do
 		what_it_is =
 			Request.new_request
 			|> Request.with_token
 			|> Request.with_url(["activities"])
 			|> Request.with_method(:post)
 			|> Request.with_data([%{feed: "user", name: "sean"}])
 		what_it_should_be = 
 			%Request{
 				url: "https://us-east-api.getstream.io/api/v1.0/activities/?api_key=fd673z8568xs",
 				token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3Rpb24iOiIqIiwiZmVlZF9pZCI6IioiLCJyZXNvdXJjZSI6IioifQ.VMFhIAnimoxSR7BXdvk_44JGXZazJx0hNldhK_LAjRs",
 				method: :post,
 				data: "[{\"name\":\"sean\",\"feed\":\"user\"}]"
 			}
 		assert what_it_is == what_it_should_be
 	end

 	test "pipeline generates proper activity" do
 		actor = %Feed{slug: "user", id: "123", feed: []}
 		what_it_is = 
 			actor
 			|> Activity.create 
 			|> Activity.with_verb("add")
 			|> Activity.with_object("picture:10")
 			|> Activity.with_target(["notifications:10"])
 			|> Activity.with_time("2017")
 			|> Activity.with_foreign_id("picture:10")
 			|> Activity.with_custom_fields(%{message: "hey"})
 		what_it_should_be = 
 			%Activity{
 				actor: %Feed{slug: "user", id: "123", feed: []},
 				verb: "add",
 				object: "picture:10",
 				target: ["notifications:10"],
 				time: "2017",
 				foreign_id: "picture:10",
 				custom_fields: %{message: "hey"}
 			}
 		assert what_it_is == what_it_should_be
 	end

 	test "properly flattens activity struct" do
 		activity = %Activity{actor: %Feed{slug: "user", id: "789", feed: []}, verb: "added", object: "picture:10", custom_fields: %{message: "hello"}}
 		assert StreamElixir.Activities.flatten(Map.from_struct(activity)) == %Activity{actor: %Feed{slug: "user", id: "789", feed: []}, verb: "added", object: "picture:10", message: "hello"}
 	end

end
