defmodule MyApp.Parser do
  @moduledoc """
  Parses JSON responses into domain-specific structs.
  """
  alias MyApp.{Item, Detail, Metadata}

  @doc """
  Parses the JSON response and returns a list of `Item` structs.
  """
  def parse_items(json_response) do
    with {:ok, decoded} <- Jason.decode(json_response),
         %{"data" => items} <- decoded do
      # Transform each item in the "data" list into our Item struct.
      Enum.map(items, &build_item/1)
    else
      # In case of any error, return an error tuple.
      _ -> {:error, "Invalid JSON structure"}
    end
  end

  # Private helper that builds an Item struct from a map.
  defp build_item(%{"id" => id, "name" => name, "details" => details}) do
    %Item{
      id: id,
      name: name,
      details: %Detail{
        description: details["description"],
        metadata: %Metadata{
          size: details["metadata"]["size"],
          color: details["metadata"]["color"]
        }
      }
    }
  end
end
