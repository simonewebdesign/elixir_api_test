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

  @tag :skip
  test "fetch_items_httpc returns a list of items", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, @json_response)
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_items_httpc(url)

    assert is_list(result)
    assert length(result) == 2

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

  @tag :skip
  test "fetch_items_httpc handles non-200 response", %{bypass: bypass} do
    # Simulate a 500 Internal Server Error.
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 500, "Internal Server Error")
    end)

    url = "http://localhost:#{bypass.port}/api/items"
    result = APIClient.fetch_items_httpc(url)
    assert {:error, _} = result
  end
end
