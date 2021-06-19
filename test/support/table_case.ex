defmodule Robosseum.TableCase do
  use ExUnit.CaseTemplate

  import Robosseum.Factory

  alias Robosseum.Server.{Card, Table}

  setup do
    table = insert!(:table, name: "Table1") |> Table.new()
    insert!(:player, table_id: table.id, name: "P1")
    insert!(:player, table_id: table.id, name: "P2")
    insert!(:player, table_id: table.id, name: "P3")
    table = Table.new_game(table)
    table = Table.new_round(table)
    table = %Table{table | deck: deck()}
    {:ok, table: table}
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

