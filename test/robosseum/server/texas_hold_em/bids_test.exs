defmodule Robosseum.TexasHoldEm.Server.BidsTest do
  use Robosseum.DataCase
  alias Robosseum.Server.{Player, TexasHoldEm.Bids, Table}

  describe "#blinds" do
    test "4 players" do
      table = %Table{
        stage: ["blinds", "normal"],
        blind: 5,
        dealer: 0,
        players: [
          %Player{name: "P1", chips: 100},
          %Player{name: "P2", chips: 200},
          %Player{name: "P3", chips: 300},
          %Player{name: "P4", chips: 50}
        ]
      }

      new_state = Bids.blinds(table)

      assert match?(
               %Table{
                 pot: 15,
                 stage: ["deal", "normal"],
                 active_player: 3,
                 players: [
                   %Player{name: "P1", status: "active", chips: 100, to_call: 10, bids: 0},
                   %Player{name: "P2", status: "blind", chips: 195, to_call: 5, bids: 5},
                   %Player{name: "P3", status: "blind", chips: 290, to_call: 0, bids: 10},
                   %Player{name: "P4", status: "active", chips: 50, to_call: 10, bids: 0}
                 ]
               },
               new_state
             )
    end

    test "2 players" do
      table = %Table{
        stage: ["blinds", "normal"],
        blind: 5,
        dealer: 0,
        players: [
          %Player{name: "P1", chips: 100},
          %Player{name: "P2", chips: 200}
        ]
      }

      new_state = Bids.blinds(table)

      assert match?(
               %Table{
                 pot: 15,
                 stage: ["deal", "normal"],
                 active_player: 0,
                 players: [
                   %Player{name: "P1", status: "blind", chips: 95, to_call: 5, bids: 5},
                   %Player{name: "P2", status: "blind", chips: 190, to_call: 0, bids: 10}
                 ]
               },
               new_state
             )
    end
  end

  describe "#bid" do
    test "player bids" do
      table = %Table{
        stage: ["deal", "bid"],
        blind: 5,
        active_player: 3,
        pot: 10,
        players: [
          %Player{name: "P1", chips: 100},
          %Player{name: "P2", chips: 200},
          %Player{name: "P3", chips: 300},
          %Player{name: "P4", chips: 400}
        ]
      }

      new_state = Bids.bid(table, 50)

      assert match?(
               %Table{
                 pot: 60,
                 stage: ["deal", "bid"],
                 active_player: 0,
                 players: [
                   %Player{name: "P1", status: "active", chips: 100, to_call: 50, bids: 0},
                   %Player{name: "P2", status: "active", chips: 200, to_call: 50, bids: 0},
                   %Player{name: "P3", status: "active", chips: 300, to_call: 50, bids: 0},
                   %Player{name: "P4", status: "raised", chips: 350, to_call: 0, bids: 50}
                 ]
               },
               new_state
             )
    end
  end

  describe "#fold" do
    test "player folds" do
      table = %Table{
        stage: ["deal", "bid"],
        blind: 5,
        active_player: 3,
        pot: 10,
        players: [
          %Player{name: "P1", chips: 100},
          %Player{name: "P2", chips: 200},
          %Player{name: "P3", chips: 300},
          %Player{name: "P4", chips: 400}
        ]
      }

      new_state = Bids.fold(table)

      assert match?(
               %Table{
                 pot: 10,
                 stage: ["deal", "bid"],
                 active_player: 0,
                 players: [
                   %Player{name: "P1", status: "active", chips: 100, to_call: 0, bids: 0},
                   %Player{name: "P2", status: "active", chips: 200, to_call: 0, bids: 0},
                   %Player{name: "P3", status: "active", chips: 300, to_call: 0, bids: 0},
                   %Player{name: "P4", status: "folded", chips: 400, to_call: 0, bids: 0}
                 ]
               },
               new_state
             )
    end
  end

  describe "#player_bid" do
    test "it sets bids; to_call of others" do
      players = [
        %Player{name: "P1", chips: 100},
        %Player{name: "P2", chips: 200},
        %Player{name: "P3", chips: 300},
        %Player{name: "P4", chips: 50}
      ]

      {bid, updated_players} = Bids.player_bid(players, 1, 50)

      assert bid == 50

      assert updated_players == [
               %Player{name: "P1", status: "active", chips: 100, to_call: 50, bids: 0},
               %Player{name: "P2", status: "raised", chips: 150, to_call: 0, bids: 50},
               %Player{name: "P3", status: "active", chips: 300, to_call: 50, bids: 0},
               %Player{name: "P4", status: "active", chips: 50, to_call: 50, bids: 0}
             ]
    end

    test "it sets bids, increase to_call only what is needed" do
      players = [
        %Player{name: "P1", status: "active", chips: 100, to_call: 50, bids: 0},
        %Player{name: "P2", status: "raised", chips: 150, to_call: 0, bids: 50},
        %Player{name: "P3", status: "active", chips: 300, to_call: 50, bids: 0},
        %Player{name: "P4", status: "active", chips: 50, to_call: 50, bids: 0}
      ]

      {bid, updated_players} = Bids.player_bid(players, 2, 70)

      assert bid == 70

      assert updated_players == [
               %Player{name: "P1", status: "active", chips: 100, to_call: 70, bids: 0},
               %Player{name: "P2", status: "raised", chips: 150, to_call: 20, bids: 50},
               %Player{name: "P3", status: "raised", chips: 230, to_call: 0, bids: 70},
               %Player{name: "P4", status: "active", chips: 50, to_call: 70, bids: 0}
             ]
    end

    test "it bids what it must (to_call)" do
      players = [
        %Player{name: "P1", status: "active", chips: 100, to_call: 70, bids: 0},
        %Player{name: "P2", status: "raised", chips: 150, to_call: 20, bids: 50},
        %Player{name: "P3", status: "raised", chips: 230, to_call: 0, bids: 70},
        %Player{name: "P4", status: "active", chips: 50, to_call: 70, bids: 0}
      ]

      {bid, updated_players} = Bids.player_bid(players, 3, 20)

      assert bid == 50

      assert updated_players == [
               %Player{name: "P1", status: "active", chips: 100, to_call: 70, bids: 0},
               %Player{name: "P2", status: "raised", chips: 150, to_call: 20, bids: 50},
               %Player{name: "P3", status: "raised", chips: 230, to_call: 0, bids: 70},
               %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
             ]
    end

    test "it bids what it can (chips)" do
      players = [
        %Player{name: "P1", status: "active", chips: 100, to_call: 70, bids: 0},
        %Player{name: "P2", status: "raised", chips: 150, to_call: 20, bids: 50},
        %Player{name: "P3", status: "raised", chips: 230, to_call: 0, bids: 70},
        %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
      ]

      {bid, updated_players} = Bids.player_bid(players, 0, 150)

      assert bid == 100

      assert updated_players == [
               %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
               %Player{name: "P2", status: "raised", chips: 150, to_call: 50, bids: 50},
               %Player{name: "P3", status: "raised", chips: 230, to_call: 30, bids: 70},
               %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
             ]
    end

    test "it calls" do
      players = [
        %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
        %Player{name: "P2", status: "raised", chips: 150, to_call: 50, bids: 50},
        %Player{name: "P3", status: "raised", chips: 230, to_call: 30, bids: 70},
        %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
      ]

      {bid, updated_players} = Bids.player_bid(players, 1, 50)

      assert bid == 50

      assert updated_players == [
               %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
               %Player{name: "P2", status: "called", chips: 100, to_call: 0, bids: 100},
               %Player{name: "P3", status: "raised", chips: 230, to_call: 30, bids: 70},
               %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
             ]
    end

    test "it reraises" do
      players = [
        %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
        %Player{name: "P2", status: "called", chips: 100, to_call: 0, bids: 100},
        %Player{name: "P3", status: "raised", chips: 230, to_call: 30, bids: 70},
        %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
      ]

      {bid, updated_players} = Bids.player_bid(players, 2, 50)

      assert bid == 50

      assert updated_players == [
               %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
               %Player{name: "P2", status: "called", chips: 100, to_call: 20, bids: 100},
               %Player{name: "P3", status: "raised", chips: 180, to_call: 0, bids: 120},
               %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
             ]
    end

    test "it last calls" do
      players = [
        %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
        %Player{name: "P2", status: "called", chips: 100, to_call: 0, bids: 100},
        %Player{name: "P3", status: "raised", chips: 230, to_call: 30, bids: 70},
        %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
      ]

      {bid, updated_players} = Bids.player_bid(players, 2, 20)

      assert bid == 30

      assert updated_players == [
               %Player{name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 100},
               %Player{name: "P2", status: "called", chips: 100, to_call: 0, bids: 100},
               %Player{name: "P3", status: "called", chips: 200, to_call: 0, bids: 100},
               %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
             ]
    end
  end
end
