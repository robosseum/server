defmodule Robosseum.Server.CountersTest do
  use ExUnit.Case, async: true

  alias Robosseum.Server.Counters

  describe "new_game" do
    test "when counters is new" do
      counters = %Counters{}

      assert Counters.new_game(counters) == %Counters{
               games: 1,
               rounds: [0],
               actions: [[]]
             }
    end

    test "when counters has some milege" do
      counters = %Counters{
        games: 3,
        rounds: [3, 2, 4],
        actions: [[2, 5, 9], [4, 5], [10, 12, 13, 12]]
      }

      assert Counters.new_game(counters) == %Counters{
               games: 4,
               rounds: [0, 3, 2, 4],
               actions: [[], [2, 5, 9], [4, 5], [10, 12, 13, 12]]
             }
    end
  end

  describe "new_round" do
    test "when couters is new" do
      counters = %Counters{
        games: 1,
        rounds: [0],
        actions: [[]]
      }

      assert Counters.new_round(counters) == %Counters{
               games: 1,
               rounds: [1],
               actions: [[0]]
             }
    end

    test "when counters has some milege" do
      counters = %Counters{
        games: 3,
        rounds: [3, 2, 4],
        actions: [[2, 5, 9], [4, 5], [10, 12, 13, 12]]
      }

      assert Counters.new_round(counters) == %Counters{
               games: 3,
               rounds: [4, 2, 4],
               actions: [[0, 2, 5, 9], [4, 5], [10, 12, 13, 12]]
             }
    end
  end

  describe "new_actions" do
    test "when couters is new" do
      counters = %Counters{
        games: 1,
        rounds: [1],
        actions: [[0]]
      }

      assert Counters.new_action(counters) == %Counters{
               games: 1,
               rounds: [1],
               actions: [[1]]
             }
    end

    test "when counters has some milege" do
      counters = %Counters{
        games: 3,
        rounds: [3, 2, 4],
        actions: [[2, 5, 9], [4, 5], [10, 12, 13, 12]]
      }

      assert Counters.new_action(counters) == %Counters{
               games: 3,
               rounds: [3, 2, 4],
               actions: [[3, 5, 9], [4, 5], [10, 12, 13, 12]]
             }
    end
  end
end
