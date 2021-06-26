defmodule Features.PlayTest do
  use Robosseum.DataCase
  use Robosseum.TableCase, async: true

  alias Robosseum.Server.Table

  test "before play", %{table: table} do
    assert length(table.players) == 3
    assert table.counters.games == 1
    assert table.counters.rounds == [1]
    assert table.counters.actions == [[0]]
  end

  test "play", %{table: table} do
    # blinds
    table = Table.run_stage(table)

    %Table{players: [player1, player2, player3]} = table

    assert match?(%{status: "active", chips: 1000, bids: 0, to_call: 10}, player1)
    assert match?(%{status: "blind", chips: 995, bids: 5, to_call: 5}, player2)
    assert match?(%{status: "blind", chips: 990, bids: 10, to_call: 0}, player3)
    assert match?(%{pot: 15, stage: ["deal", "normal"], active_player: 0, dealer: 0}, table)

    # deal
    table = Table.run_stage(table)
    %Table{players: [player1, player2, player3]} = table

    assert match?(
             %{hand: [%{rank: 6, suit: "spades"}, %{rank: 10, suit: "hearts"}]},
             player1
           )

    assert match?(
             %{hand: [%{rank: 14, suit: "hearts"}, %{rank: 2, suit: "hearts"}]},
             player2
           )

    assert match?(
             %{hand: [%{rank: 13, suit: "clubs"}, %{rank: 10, suit: "spades"}]},
             player3
           )

    assert match?(%{pot: 15, stage: ["deal", "bid"], active_player: 0}, table)

    # deal bids
    table = Table.bid(table, player1.id, 20)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "raised"}, player1)
    assert match?(%{chips: 995, bids: 5, to_call: 15, status: "blind"}, player2)
    assert match?(%{chips: 990, bids: 10, to_call: 10, status: "blind"}, player3)
    assert match?(%{pot: 35, stage: ["deal", "bid"], active_player: 1}, table)

    table = Table.bid(table, player2.id, 15)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "raised"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "called"}, player2)
    assert match?(%{chips: 990, bids: 10, to_call: 10, status: "blind"}, player3)
    assert match?(%{pot: 50, stage: ["deal", "bid"], active_player: 2}, table)

    table = Table.bid(table, player3.id, 20)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 980, bids: 20, to_call: 10, status: "raised"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 10, status: "called"}, player2)
    assert match?(%{chips: 970, bids: 30, to_call: 0, status: "raised"}, player3)
    assert match?(%{pot: 70, stage: ["deal", "bid"], active_player: 0}, table)

    table = Table.bid(table, player1.id, 10)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 970, bids: 30, to_call: 0, status: "called"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 10, status: "called"}, player2)
    assert match?(%{chips: 970, bids: 30, to_call: 0, status: "raised"}, player3)
    assert match?(%{pot: 80, stage: ["deal", "bid"], active_player: 1}, table)

    table = Table.fold(table, player2.id)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 970, to_call: 0, bids: 30, status: "active"}, player1)
    assert match?(%{chips: 980, to_call: 0, bids: 20, status: "folded"}, player2)
    assert match?(%{chips: 970, to_call: 0, bids: 30, status: "active"}, player3)
    assert match?(%{pot: 80, stage: ["flop", "normal"], active_player: 2}, table)

    # flop
    table = Table.run_stage(table)
    assert match?(
             %{
               pot: 80,
               stage: ["flop", "bid"],
               board: [
                 %{rank: 8, suit: "hearts"},
                 %{rank: 10, suit: "clubs"},
                 %{rank: 9, suit: "hearts"}
               ],
               active_player: 2
             },
             table
           )

    table = Table.bid(table, player3.id, 20)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 970, bids: 30, to_call: 20, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 950, bids: 50, to_call: 0, status: "raised"}, player3)
    assert match?(%{pot: 100, stage: ["flop", "bid"], active_player: 0}, table)

    table = Table.bid(table, player1.id, 35)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "raised"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 950, bids: 50, to_call: 15, status: "raised"}, player3)
    assert match?(%{pot: 135, stage: ["flop", "bid"], active_player: 2}, table)

    table = Table.bid(table, player3.id, 15)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "active"}, player3)
    assert match?(%{pot: 150, stage: ["river", "normal"], active_player: 2}, table)

    # river
    table = Table.run_stage(table)

    assert match?(
             %{
               pot: 150,
               stage: ["river", "bid"],
               board: [
                 %{rank: 5, suit: "clubs"},
                 %{rank: 8, suit: "hearts"},
                 %{rank: 10, suit: "clubs"},
                 %{rank: 9, suit: "hearts"}
               ],
               active_player: 2
             },
             table
           )

    table = Table.bid(table, player3.id, 0)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "called"}, player3)
    assert match?(%{pot: 150, stage: ["river", "bid"], active_player: 0}, table)

    table = Table.bid(table, player1.id, 0)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 935, bids: 65, to_call: 0, status: "active"}, player3)
    assert match?(%{pot: 150, stage: ["turn", "normal"], active_player: 2}, table)

    # turn
    table = Table.run_stage(table)

    assert match?(
             %{
               pot: 150,
               stage: ["turn", "bid"],
               board: [
                 %{rank: 14, suit: "diamonds"},
                 %{rank: 5, suit: "clubs"},
                 %{rank: 8, suit: "hearts"},
                 %{rank: 10, suit: "clubs"},
                 %{rank: 9, suit: "hearts"}
               ],
               active_player: 2
             },
             table
           )

    table = Table.bid(table, player3.id, 20)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 935, bids: 65, to_call: 20, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 915, bids: 85, to_call: 0, status: "raised"}, player3)
    assert match?(%{pot: 170, stage: ["turn", "bid"], active_player: 0}, table)

    table = Table.bid(table, player1.id, 20)
    %Table{players: [player1, player2, player3]} = table
    assert match?(%{chips: 915, bids: 85, to_call: 0, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 20, to_call: 0, status: "folded"}, player2)
    assert match?(%{chips: 915, bids: 85, to_call: 0, status: "active"}, player3)
    assert match?(%{pot: 190, stage: ["end", "normal"], active_player: 2}, table)

    # ending
    table = Table.run_stage(table)
    %Table{winner: winner, players: [_, _, player3]} = table
    assert winner.id == player3.id
    assert match?(%{chips: 1105}, player3)

    # new round
    table = Table.run_stage(table)
    %Table{dealer: dealer, players: [player1, player2, player3]} = table
    assert match?(%{chips: 915, bids: 0, to_call: 0, status: "active"}, player1)
    assert match?(%{chips: 980, bids: 0, to_call: 0, status: "active"}, player2)
    assert match?(%{chips: 1105, bids: 0, to_call: 0, status: "active"}, player3)
    assert dealer == 1
  end
end

