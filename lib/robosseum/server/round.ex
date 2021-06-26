defmodule Robosseum.Server.Round do
  import Robosseum.Server.Utils

  alias Robosseum.Server.{Table, Player}

  def done?(%Table{players: players}) do
    active_players = Enum.filter(players, &Player.active?/1)

    cond do
      length(active_players) < 2 ->
        true

      Enum.all?(active_players, &(&1.status == "called")) ->
        true

      true ->
        false
    end
  end

  def next(table = %Table{players: players, dealer: dealer}) do
    players =
      players
      |> Enum.filter(&(&1.status != "out"))
      |> Enum.map(&%{&1 | status: "active", to_call: 0, hand: []})

    new_dealer = mod(dealer + 1, length(players))
    table = Table.new_round(table)

    %Table{
      table
      | players: players,
      dealer: new_dealer,
      pot: 0
    }
  end

  def next_stage(table, stages) do
    case done?(table) do
      true -> next_stage_without_bids(table.stage, stages)
      false -> next_stage_all(table.stage, stages)
    end
  end

  defp next_stage_all(stage, stages) do
    Enum.at(stages, Enum.find_index(stages, &(&1 == stage)) + 1)
  end

  defp next_stage_without_bids(stage, stages) do
    next_stage = next_stage_all(stage, stages)

    case next_stage do
      [_, "bid"] ->
        next_stage_without_bids(next_stage, stages)

      _ ->
        next_stage
    end
  end
end
