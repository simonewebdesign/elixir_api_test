defmodule MyApp.APIClientTest do
  use ExUnit.Case, async: true
  alias MyApp.{APIClient, Item, Detail, Metadata}

  # Bypass will allow us to simulate HTTP responses.
  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  # A realistic JSON response similar to what the API would return.
  @json_response ~s({
    "data": [
      {
        "id": 1,
        "name": "Item One",
        "details": {
          "description": "An item",
          "metadata": {
            "size": "large",
            "color": "red"
          }
        }
      },
      {
        "id": 2,
        "name": "Item Two",
        "details": {
          "description": "Another item",
          "metadata": {
            "size": "small",
            "color": "blue"
          }
        }
      }
    ]
  })

  test "fetch_items returns a list of items", %{bypass: bypass} do
    # Configure Bypass to respond with a valid JSON.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, @json_response)
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_items(url)

    # Verify that we received a list of 2 items.
    assert is_list(result)
    assert length(result) == 2

    # Assert that the first item is correctly transformed.
    [first_item | _] = result

    expected = %Item{
      id: 1,
      name: "Item One",
      details: %Detail{
        description: "An item",
        metadata: %Metadata{
          size: "large",
          color: "red"
        }
      }
    }

    assert first_item == expected
  end

  test "fetch_items handles non-200 response", %{bypass: bypass} do
    # Simulate a 404 response.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 404, "Not Found")
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_items(url)
    assert {:error, _} = result
  end

  @json_response_small ~s({
    "id": 1,
    "name": "Item One",
    "relatedProducts": [123, 456]
  })

  test "fetch_json_as_map/1 returns a map", %{bypass: bypass} do
    # Configure Bypass to respond with a valid JSON.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, @json_response_small)
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_json_as_map(url)

    assert is_map(result)

    expected = %{
      "id" => 1,
      "name" => "Item One",
      "relatedProducts" => [123, 456]
    }

    assert result == expected
  end

  test "fetch_json_as_map/1 handles invalid JSON", %{bypass: bypass} do
    # Configure Bypass to respond with invalid JSON.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, "{invalid json")
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_json_as_map(url)

    assert {:error, "Failed to decode JSON:" <> _} = result
  end

  test "fetch_json_as_map/1 handles non-200 response", %{bypass: bypass} do
    # Configure Bypass to respond with a 404 status.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 404, "Not Found")
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_json_as_map(url)

    assert {:error, "Unexpected status code: 404. Response: Not Found"} = result
  end

  test "fetch_json_as_map/1 handles network error", %{bypass: bypass} do
    # Configure Bypass to simulate a network error by not responding.
    Bypass.down(bypass)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_json_as_map(url)

    assert {:error, %HTTPoison.Error{}} = result
  end
end
