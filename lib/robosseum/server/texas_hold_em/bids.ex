defmodule Robosseum.Server.TexasHoldEm.Bids do
  import Robosseum.Server.Utils

  alias Robosseum.Server.{Table, Round, TexasHoldEm}

  @doc """
  Bids small and big blinds at the same time at the beginning of the round
  """
  def blinds(
        table = %Table{
          blind: blind,
          dealer: dealer,
          players: players
        }
      ) do
    # In two player game
    dealer = if Enum.count(players) == 2, do: dealer - 1, else: dealer

    small_blind_index = mod(dealer + 1, length(players))
    big_blind_index = mod(dealer + 2, length(players))

    {small_blind, players} = player_bid(players, small_blind_index, blind, "blind")
    {big_blind, players} = player_bid(players, big_blind_index, blind * 2, "blind")

    %{
      table
      | players: players,
        pot: small_blind + big_blind,
        stage: Round.next_stage(table, TexasHoldEm.stages()),
        active_player: mod(dealer + 3, length(players))
    }
    |> Table.new_action(%{action: "blinds", message: "Put blinds"})
  end

  @doc """
  A player bids
  """
  def bid(
        table = %{
          game: %{players: players},
          round: %{active_player: active_player_index, pot: pot}
        },
        bid
      ) do
    active_player = Enum.at(players, active_player_index)

    {bid, players} = player_bid(players, active_player_index, bid)

    %{
      table
      | game: %{
          table.game
          | players: players
        },
        round: %{
          table.round
          | active_player: next_active_player(players, active_player_index),
            pot: pot + bid
        }
    }
    |> Table.new_action(%{
      action: "bid",
      active_player: active_player_index,
      bid: bid,
      message: "#{active_player.name} bid #{bid}"
    })
  end

  @doc """
  A player folds a round
  """
  def fold(table = %{game: %{players: players}, round: %{active_player: active_player_index}}) do
    active_player = Enum.at(players, active_player_index)
    players = List.update_at(players, active_player_index, &%{&1 | status: "folded", to_call: 0})

    %{
      table
      | game: %{
          table.game
          | players: players
        },
        round: %{
          table.round
          | active_player: next_active_player(players, active_player_index)
        }
    }
    |> Table.new_action(%{
      action: "fold",
      active_player: active_player_index,
      message: "#{active_player.name} folded"
    })
  end

  # private

  @doc """
  Update players after player bid

  - if bid is equal to player's to_call, it means the player called
  - if bid is larger than player's to_call, it means the player raised
  - if bid is equal than player's chips, it means the player went all in
  - bid cant be bigger than player chips
  - bid cant be smalled than to_call unless all_in
  """
  def player_bid(players, player_index, bid, status \\ nil) do
    player = Enum.at(players, player_index)

    bid = if player.to_call <= bid, do: bid, else: player.to_call

    remaining_chips = player.chips - bid

    {status, remaining_chips, bid} =
      cond do
        remaining_chips <= 0 -> {"all_in", 0, player.chips}
        bid > player.to_call -> {status || "raised", remaining_chips, bid}
        bid == player.to_call -> {status || "called", remaining_chips, bid}
      end

    # If bid is smaller than to_call, min_stack remains the same
    min_stack =
      if player.to_call <= bid, do: player.bids + bid, else: player.bids + player.to_call

    players =
      players
      |> List.update_at(
        player_index,
        &%{
          &1
          | status: status,
            to_call: 0,
            bids: player.bids + bid,
            chips: remaining_chips
        }
      )
      |> update_other_players(player_index, min_stack)

    {bid, players}
  end

  defp update_other_players(players, active_player_index, min_stack) do
    players
    |> Enum.with_index()
    |> Enum.map(fn {player, index} ->
      cond do
        active_player_index == index -> player
        player.status == "folded" -> player
        player.status == "all_in" -> player
        true -> Map.put(player, :to_call, min_stack - player.bids)
      end
    end)
  end
end
