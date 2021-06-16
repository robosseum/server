defmodule Robosseum.Server.TexasHoldEm do
  import Robosseum.Server.Utils
  alias Robosseum.Server.{Game, Round, Player, TexasHoldEm.Stages, TexasHoldEm.Bids}

  @stages [
    ["blinds", "normal"],
    ["deal", "normal"],
    ["deal", "bid"],
    ["flop", "normal"],
    ["flop", "bid"],
    ["river", "normal"],
    ["river", "bid"],
    ["turn", "normal"],
    ["turn", "bid"],
    ["end", "normal"],
    ["cleanup", "normal"]
  ]

  def stages, do: @stages

  def run_stage(["blinds", "normal"], table), do: Bids.blinds(table)
  def run_stage(["deal", "normal"], table), do: Stages.deal(table)
  def run_stage(["flop", "normal"], table), do: Stages.flop(table)
  def run_stage(["turn", "normal"], table), do: Stages.turn(table)
  def run_stage(["river", "normal"], table), do: Stages.river(table)
  def run_stage(["end", "normal"], table), do: Stages.ending(table)

  def run_stage(["cleanup", "normal"], table) do
    if Game.done?(table) do
      Game.next(table)
    else
      Round.next(table)
    end
  end

  def stage_done?(players) do
    Enum.all?(players, fn player ->
      Enum.member?(["called", "all_in", "folded", "raised"], player.status) && player.to_call == 0
    end)
  end

  def next_stage(%{game: %{players: players, dealer: dealer}} = table) do
    case stage_done?(players) do
      false ->
        table

      true ->
        %{
          table
          | game: %{
              table.game
              | players:
                  Enum.map(
                    players,
                    &%{&1 | status: if(Player.active?(&1), do: "active", else: &1.status)}
                  )
            },
            round: %{
              table.round
              | active_player: next_active_player(players, dealer),
                stage: Round.next_stage(table, @stages)
            }
        }
    end
  end
end
