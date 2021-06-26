defmodule Robosseum.Server.TableTest do
  use Robosseum.DataCase

  alias Robosseum.Server.{Table}

  test ".new_game" do
    table = insert!(:table, counters: %{})

    insert!(:player, table_id: table.id, name: "P1")
    insert!(:player, table_id: table.id, name: "P2")
    insert!(:player, table_id: table.id, name: "P3")

    new_state =
      table.id
      |> Table.get_table()
      |> Table.new_game()

    assert new_state.counters.games == 1

    assert match?(
             %Table{
               players: [
                 %{name: "P1", chips: 1000, status: "active"},
                 %{name: "P2", chips: 1000, status: "active"},
                 %{name: "P3", chips: 1000, status: "active"}
               ],
               dealer: 0,
               blind: 5
             },
             new_state
           )
  end

  test ".new_round" do
    table = insert!(:table, counters: %{})

    insert!(:player, table_id: table.id, name: "P1")
    insert!(:player, table_id: table.id, name: "P2")
    insert!(:player, table_id: table.id, name: "P3")

    new_state =
      table.id
      |> Table.get_table()
      |> Table.new_game()
      |> Table.new_round()

    assert new_state.counters.rounds == [1]
    assert new_state.deck != []

    assert match?(
             %Table{
               players: [
                 %{name: "P1", chips: 1000, status: "active"},
                 %{name: "P2", chips: 1000, status: "active"},
                 %{name: "P3", chips: 1000, status: "active"}
               ],
               board: [],
               pot: 0,
               active_player: 1,
               stage: ["blinds", "normal"]
             },
             new_state
           )
  end

  test ".run_stage" do
    table = insert!(:table, counters: %{})

    insert!(:player, table_id: table.id, name: "P1")
    insert!(:player, table_id: table.id, name: "P2")
    insert!(:player, table_id: table.id, name: "P3")

    new_state =
      table.id
      |> Table.get_table()
      |> Table.new_game()
      |> Table.new_round()
      |> Table.run_stage()

    assert match?(
             %Table{
               players: [
                 %{name: "P1", chips: 1000, bids: 0, to_call: 10, status: "active"},
                 %{name: "P2", chips: 995, bids: 5, to_call: 5, status: "blind"},
                 %{name: "P3", chips: 990, bids: 10, to_call: 0, status: "blind"}
               ],
               pot: 15,
               active_player: 0,
               stage: ["deal", "normal"]
             },
             new_state
           )

    round_action =
      Robosseum.Repo.one!(from a in Robosseum.Models.Action, order_by: a.index, limit: 1)

    assert match?(%{action: "blinds", message: "Put blinds"}, round_action)
  end
end
