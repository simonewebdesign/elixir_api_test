defmodule MyAppTest do
  use ExUnit.Case
  doctest MyApp

  test "greets the world" do
    assert MyApp.hello() == :world
  end

  test "get_owned_vehicles returns the vehicles" do
    assert MyApp.get_owned_vehicles(["P1", "P2"]) == [
             %{person_id: "P1", vehicle_id: "V3"},
             %{person_id: "P1", vehicle_id: "V8"},
             %{person_id: "P2", vehicle_id: "V6"}
           ]
  end

  test "returns the expected response" do
    policies = [
      %{person_id: "P1", vehicle_id: "V8"},
      %{person_id: "P2", vehicle_id: "V6"}
    ]

    expected = [
      %{person_id: "P1", vehicle_id: "V3"}
    ]

    assert MyApp.find_potential_upsells(policies) == expected
  end
end
