defmodule Robosseum.Server.TexasHoldEm do
  import Robosseum.Server.Utils
  alias Robosseum.Server.{Table, Round, Player, TexasHoldEm.Stages, TexasHoldEm.Bids}

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

  @doc """
  Proxy methods
  """
  def run_stage(["blinds", "normal"], table), do: Bids.blinds(table)
  def run_stage(["deal", "normal"], table), do: Stages.deal(table)
  def run_stage(["flop", "normal"], table), do: Stages.flop(table)
  def run_stage(["turn", "normal"], table), do: Stages.turn(table)
  def run_stage(["river", "normal"], table), do: Stages.river(table)
  def run_stage(["end", "normal"], table), do: Stages.ending(table)

  def run_stage(["cleanup", "normal"], table) do
    if game_done?(table) do
      Table.new_game(table)
    else
      Round.next(table)
    end
  end

  @doc """
  Game is done when there is only one player which is not out
  """
  def game_done?(%Table{players: players}) do
    active_players = Enum.filter(players, &(&1.status != :out))

    length(active_players) == 1
  end

  @doc """
  If stage is done:
  - set players statuses for new stage
  - set new active_player
  - set new stage
  """
  def next_stage(%Table{players: players, dealer: dealer} = table) do
    case stage_done?(players) do
      false ->
        table

      true ->
        %{
          table
          | players: Player.set_status_for_new_stage(players),
            active_player: next_active_player(players, dealer),
            stage: Round.next_stage(table, @stages)
        }
    end
  end

  @doc """
  Stage is done when there is no player left who needs to bid
  """
  def stage_done?(players) do
    Enum.all?(players, fn player ->
      Enum.member?(["called", "all_in", "folded", "raised"], player.status) && player.to_call == 0
    end)
  end
end
