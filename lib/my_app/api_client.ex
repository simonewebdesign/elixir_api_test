defmodule MyApp.APIClient do
  @moduledoc """
  Fetches items from an API endpoint using different HTTP client approaches.
  """
  alias MyApp.Parser

  @doc """
  Fetch items using HTTPoison.

  **Best Practices:**
    - Handle non-200 responses and errors gracefully.
    - Pass in options (e.g. `recv_timeout`) to avoid indefinite blocking.
  """
  def fetch_items_httpoison(url) do
    case HTTPoison.get(url, [], recv_timeout: 5000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Parser.parse_items(body)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        # Handle unexpected status codes (could also log the response).
        {:error, "Unexpected status code: #{status_code}. Response: #{body}"}

      {:error, %HTTPoison.Error{} = error} ->
        # Return an error tuple so the caller can decide how to handle it.
        {:error, error}
    end
  end

  @doc """
  Fetch items using the built-in :httpc client.

    - Ensures the :inets application is started.
    - Converts the URL to a charlist because :httpc expects charlists.
    - Requests the body as binary.
  """
  def fetch_items_httpc(url) do
    # Ensure the :inets application is running.
    :inets.start()
    request = {String.to_charlist(url), []}

    case :httpc.request(:get, request, [], [{:body_format, :binary}]) do
      {:ok, {{~c"HTTP/1.1", 200, ~c"OK"}, _headers, body}} ->
        Parser.parse_items(body)

      {:ok, {{_http_version, status_code, _reason_phrase}, _headers, body}} ->
        {:error, "Unexpected status code: #{status_code}. Response: #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
