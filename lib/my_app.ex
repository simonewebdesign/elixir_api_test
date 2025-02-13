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
  def get_owned_vehicles(person_ids) do
    cond do
      "P1" in person_ids and "P2" in person_ids ->
        [
          %{person_id: "P1", vehicle_id: "V3"},
          %{person_id: "P1", vehicle_id: "V8"},
          %{person_id: "P2", vehicle_id: "V6"}
        ]

      "P3" in person_ids and "P2" in person_ids ->
        [
          %{person_id: "P2", vehicle_id: "V6"},
          %{person_id: "P3", vehicle_id: "V9"},
          %{person_id: "P3", vehicle_id: "V5"},
          %{person_id: "P3", vehicle_id: "V2"}
        ]

      true ->
        # here we would actually call the API
        []
    end
  end

  # function find_potential_upsells(policies: List<Policy>): List<UpsellOpportunity>
  def find_potential_upsells(policies) do
    policies
    # get person ids
    |> Enum.map(fn policy -> policy[:person_id] end)
    # call the API
    |> get_owned_vehicles()
    |> Enum.filter(fn owned_vehicle ->
      Enum.any?(policies, fn policy -> upsell_opportunity?(policy, owned_vehicle) end)
    end)
  end

  defp upsell_opportunity?(policy, owned_vehicle) do
    policy[:person_id] == owned_vehicle[:person_id] and
      policy[:vehicle_id] != owned_vehicle[:vehicle_id]
  end
end
