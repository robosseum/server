defmodule Robosseum.TableCase do
  use ExUnit.CaseTemplate

  import Robosseum.Factory

  alias Robosseum.Server.{Card, Table}

  setup do
    table = insert!(:table, name: "Table1", counters: %{})
    insert!(:player, table_id: table.id, name: "P1")
    insert!(:player, table_id: table.id, name: "P2")
    insert!(:player, table_id: table.id, name: "P3")
    table = 
      table.id
      |> Table.get_table()
      |> Table.new_game()
      |> Table.new_round()
    {:ok, table: %Table{table | deck: deck()}}
  end

  def deck do
    [
      "6s",
      "Th",
      "Ah",
      "2h",
      "Kc",
      "Ts",
      "Jd",
      "8h",
      "Tc",
      "9h",
      "Jh",
      "5c",
      "5h",
      "Ad",
      "Jc",
      "As",
      "5s",
      "7s",
      "2d",
      "Ac",
      "Td",
      "9d",
      "Qs",
      "6h",
      "4s",
      "3d",
      "8d",
      "Kh",
      "8s",
      "Ks",
      "3c",
      "5d",
      "7h",
      "7c",
      "9s",
      "Js",
      "4c",
      "4d",
      "3h",
      "Qc",
      "9c",
      "7d",
      "Qd",
      "Kd",
      "6c",
      "4h",
      "2c",
      "3s",
      "6d",
      "Qh",
      "2s",
      "8c"
    ]
    |> Card.from_string()
  end
end

