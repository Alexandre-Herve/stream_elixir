defmodule StreamElixirTest do
  use ExUnit.Case
  doctest StreamElixir

  
 	test "creates correct god token" do
 		assert StreamElixir.create_jwt == "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3Rpb24iOiIqIiwiZmVlZF9pZCI6IioiLCJyZXNvdXJjZSI6IioifQ.VMFhIAnimoxSR7BXdvk_44JGXZazJx0hNldhK_LAjRs"
 	end

 	test "generates correct endpoint with no parameters" do
 		assert StreamElixir.create_url(["activities"]) == "https://us-east-api.getstream.io/api/v1.0/activities/?api_key=fd673z8568xs"
 	end

 	test "generates correct endpoint with 1 parameter" do
 		assert StreamElixir.create_url(["feed", "user", "123", "followers"], %{offset: 10}) == "https://us-east-api.getstream.io/api/v1.0/feed/user/123/followers/?api_key=fd673z8568xs&offset=10"
 	end

 	test "generates correct endpoint with multiple parameters" do
 		assert StreamElixir.create_url(["feed", "timeline_aggregated", "123"], %{limit: 10, offset: 10}) == "https://us-east-api.getstream.io/api/v1.0/feed/timeline_aggregated/123/?api_key=fd673z8568xs&limit=10&offset=10"
 	end

 	
end
