defmodule MyApp do
  @moduledoc """
  Documentation for `MyApp`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MyApp.hello()
      :world

  """
  def hello do
    :world
  end

  # function get_owned_vehicles(person_ids: List<String>): List<OwnedVehicle>
  # “Real” third party source behind this function
  def get_owned_vehicles(_person_ids) do
    [
      %{person_id: "P1", vehicle_id: "V3"},
      %{person_id: "P1", vehicle_id: "V8"},
      %{person_id: "P2", vehicle_id: "V6"}
    ]
  end

  # function find_potential_upsells(policies: List<Policy>): List<UpsellOpportunity>
  def find_potential_upsells(policies) do
    person_ids = Enum.map(policies, fn policy -> policy[:person_id] end)

    person_ids
    |> get_owned_vehicles()
    |> Enum.filter(fn owned_vehicle ->
      Enum.any?(policies, fn p ->
        p[:person_id] == owned_vehicle[:person_id] and
          p[:vehicle_id] != owned_vehicle[:vehicle_id]
      end)
    end)
  end
end

# person_ids
# |> get_owned_vehicles
# |> find_potential_upsells
