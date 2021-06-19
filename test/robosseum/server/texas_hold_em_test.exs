defmodule Robosseum.Server.TexasHoldEmTest do
  use ExUnit.Case, async: true
  alias Robosseum.Server.{Player, TexasHoldEm}

  describe "#next_stage" do
    test "4 players / no bids" do
      players = [
        %Player{name: "P1", status: "active", chips: 100, to_call: 10, bids: 0},
        %Player{name: "P2", status: "blind", chips: 195, to_call: 5, bids: 5},
        %Player{name: "P3", status: "blind", chips: 290, to_call: 0, bids: 10},
        %Player{name: "P4", status: "active", chips: 50, to_call: 10, bids: 0}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "4 players / first call" do
      players = [
        %Player{name: "P1", status: "active", chips: 100, to_call: 10, bids: 0},
        %Player{name: "P2", status: "blind", chips: 195, to_call: 5, bids: 5},
        %Player{name: "P3", status: "blind", chips: 290, to_call: 0, bids: 10},
        %Player{name: "P4", status: "called", chips: 40, to_call: 0, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "4 players / first fold" do
      players = [
        %Player{name: "P1", status: "folded", chips: 100, to_call: 0, bids: 0},
        %Player{name: "P2", status: "blind", chips: 195, to_call: 5, bids: 5},
        %Player{name: "P3", status: "blind", chips: 290, to_call: 0, bids: 10},
        %Player{name: "P4", status: "called", chips: 40, to_call: 0, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "4 players / one blind left" do
      players = [
        %Player{name: "P1", status: "folded", chips: 100, to_call: 0, bids: 0},
        %Player{name: "P2", status: "called", chips: 190, to_call: 0, bids: 10},
        %Player{name: "P3", status: "blind", chips: 290, to_call: 0, bids: 10},
        %Player{name: "P4", status: "called", chips: 40, to_call: 0, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "4 players / first raise" do
      players = [
        %Player{name: "P1", status: "folded", chips: 100, to_call: 0, bids: 0},
        %Player{name: "P2", status: "called", chips: 190, to_call: 10, bids: 10},
        %Player{name: "P3", status: "raised", chips: 290, to_call: 0, bids: 20},
        %Player{name: "P4", status: "called", chips: 40, to_call: 10, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "4 players / last call" do
      players = [
        %Player{name: "P1", status: "folded", chips: 100, to_call: 0, bids: 0},
        %Player{name: "P2", status: "called", chips: 190, to_call: 0, bids: 10},
        %Player{name: "P3", status: "called", chips: 290, to_call: 0, bids: 10},
        %Player{name: "P4", status: "called", chips: 40, to_call: 0, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === true
    end

    test "4 players / last all_in" do
      players = [
        %Player{name: "P1", status: "folded", chips: 100, to_call: 0, bids: 0},
        %Player{name: "P2", status: "called", chips: 190, to_call: 40, bids: 10},
        %Player{name: "P3", status: "called", chips: 290, to_call: 40, bids: 10},
        %Player{name: "P4", status: "all_in", chips: 0, to_call: 0, bids: 50}
      ]

      assert TexasHoldEm.stage_done?(players) === false
    end

    test "3 players" do
      players = [
        %Player{name: "P1", status: "called", chips: 100, to_call: 0, bids: 10},
        %Player{name: "P2", status: "folded", chips: 190, to_call: 0, bids: 0},
        %Player{name: "P3", status: "raised", chips: 290, to_call: 0, bids: 10}
      ]

      assert TexasHoldEm.stage_done?(players) === true
    end
  end
end

