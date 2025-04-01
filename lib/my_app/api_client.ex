defmodule MyApp.APIClient do
  alias MyApp.Parser

  def fetch_items(url) do
    case HTTPoison.get(url, [], recv_timeout: 5000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Parser.parse_items(body)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "Unexpected status code: #{status_code}. Response: #{body}"}

      {:error, %HTTPoison.Error{} = error} ->
        {:error, error}
    end
  end

  def fetch_json_as_map(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, decoded} <- Jason.decode(body) do
      decoded
    else
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "Unexpected status code: #{status_code}. Response: #{body}"}

      {:error, %HTTPoison.Error{} = error} ->
        {:error, error}

      {:error, %Jason.DecodeError{} = error} ->
        {:error, "Failed to decode JSON: #{inspect(error)}"}
    end
  end
end
