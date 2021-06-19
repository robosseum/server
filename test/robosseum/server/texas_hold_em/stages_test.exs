defmodule Robosseum.Server.TexasHoldEm.StagesTest do
  use ExUnit.Case, async: true
  alias Robosseum.Server.{Player, TexasHoldEm.Stages}

  describe "#clear_pot" do
    test "4 players / no all_in" do
      players = [
        %Player{id: 1, name: "P1", status: "called", chips: 100, to_call: 0, bids: 50},
        %Player{id: 2, name: "P2", status: "called", chips: 195, to_call: 0, bids: 50},
        %Player{id: 3, name: "P3", status: "called", chips: 290, to_call: 0, bids: 50},
        %Player{id: 4, name: "P4", status: "called", chips: 50, to_call: 0, bids: 50}
      ]

      assert Stages.clear_pot(players, %Player{id: 4, name: "P4", bids: 50}) == [
               %Player{id: 1, name: "P1", status: "called", chips: 100, to_call: 0, bids: 0},
               %Player{id: 2, name: "P2", status: "called", chips: 195, to_call: 0, bids: 0},
               %Player{id: 3, name: "P3", status: "called", chips: 290, to_call: 0, bids: 0},
               %Player{id: 4, name: "P4", status: "called", chips: 250, to_call: 0, bids: 0}
             ]
    end

    test "4 players / one all_in" do
      players = [
        %Player{id: 1, name: "P1", status: "called", chips: 100, to_call: 0, bids: 50},
        %Player{id: 2, name: "P2", status: "called", chips: 195, to_call: 0, bids: 50},
        %Player{id: 3, name: "P3", status: "called", chips: 290, to_call: 0, bids: 50},
        %Player{id: 4, name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 30}
      ]

      assert Stages.clear_pot(players, %Player{id: 4, name: "P4", bids: 30}) == [
               %Player{id: 1, name: "P1", status: "called", chips: 120, to_call: 0, bids: 0},
               %Player{id: 2, name: "P2", status: "called", chips: 215, to_call: 0, bids: 0},
               %Player{id: 3, name: "P3", status: "called", chips: 310, to_call: 0, bids: 0},
               %Player{id: 4, name: "P4", status: "all_in", chips: 120, to_call: 0, bids: 0}
             ]
    end

    test "4 players / two all_in / lowest won" do
      players = [
        %Player{id: 1, name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 50},
        %Player{id: 2, name: "P2", status: "called", chips: 195, to_call: 0, bids: 70},
        %Player{id: 3, name: "P3", status: "called", chips: 290, to_call: 0, bids: 70},
        %Player{id: 4, name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 30}
      ]

      assert Stages.clear_pot(players, %Player{id: 4, name: "P4", bids: 30}) == [
               %Player{id: 1, name: "P1", status: "all_in", chips: 20, to_call: 0, bids: 0},
               %Player{id: 2, name: "P2", status: "called", chips: 235, to_call: 0, bids: 0},
               %Player{id: 3, name: "P3", status: "called", chips: 330, to_call: 0, bids: 0},
               %Player{id: 4, name: "P4", status: "all_in", chips: 120, to_call: 0, bids: 0}
             ]
    end

    test "4 players / two all_in / penlowest won" do
      players = [
        %Player{id: 1, name: "P1", status: "all_in", chips: 0, to_call: 0, bids: 50},
        %Player{id: 2, name: "P2", status: "called", chips: 195, to_call: 0, bids: 70},
        %Player{id: 3, name: "P3", status: "called", chips: 290, to_call: 0, bids: 70},
        %Player{id: 4, name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 30}
      ]

      assert Stages.clear_pot(players, %Player{id: 1, name: "P1", bids: 50}) == [
               %Player{id: 1, name: "P1", status: "all_in", chips: 180, to_call: 0, bids: 0},
               %Player{id: 2, name: "P2", status: "called", chips: 215, to_call: 0, bids: 0},
               %Player{id: 3, name: "P3", status: "called", chips: 310, to_call: 0, bids: 0},
               %Player{id: 4, name: "P4", status: "out", chips: 0, to_call: 0, bids: 0}
             ]
    end
  end
end

