defmodule MyApp.Metadata do
  @moduledoc """
  Represents metadata for an item.
  """
  @enforce_keys [:size, :color]
  defstruct [:size, :color]
end

defmodule MyApp.Detail do
  @moduledoc """
  Represents details for an item including description and metadata.
  """
  @enforce_keys [:description, :metadata]
  defstruct [:description, :metadata]
end

defmodule MyApp.Item do
  @moduledoc """
  Represents an item.
  """
  @enforce_keys [:id, :name, :details]
  defstruct [:id, :name, :details]
end
