defmodule Robosseum.Server.TexasHoldEm.Stages do
  import Robosseum.Server.Utils

  alias Robosseum.Server.{Round, Player, Hand, TexasHoldEm}

  def deal(
        table = %{
          game: %{dealer: dealer, players: players},
          round: %{deck: deck}
        }
      ) do
    {deck, players} = deal_cards(players, deck, dealer, dealer)

    %{
      table
      | game: %{
          table.game
          | players: players
        },
        round: %{
          table.round
          | stage: Round.next_stage(table, TexasHoldEm.stages()),
            deck: deck
        }
    }
    |> add_action(%{action: :deal, msg: "Deal cards"})
  end

  def flop(
        table = %{
          round: %{deck: deck}
        }
      ) do
    [_burn, card1, card2, card3 | rest] = deck

    %{
      table
      | round: %{
          table.round
          | stage: Round.next_stage(table, TexasHoldEm.stages()),
            board: [card1, card2, card3],
            deck: rest
        }
    }
    |> add_action(%{action: :flop, msg: "Flop"})
  end

  def turn(
        table = %{
          round: %{deck: deck, board: board}
        }
      ) do
    [_burn, card | rest] = deck

    %{
      table
      | round: %{
          table.round
          | stage: Round.next_stage(table, TexasHoldEm.stages()),
            board: [card | board],
            deck: rest
        }
    }
    |> add_action(%{action: :turn, msg: "Turn"})
  end

  def river(
        table = %{
          round: %{deck: deck, board: board}
        }
      ) do
    [_burn, card | rest] = deck

    %{
      table
      | round: %{
          table.round
          | stage: Round.next_stage(table, TexasHoldEm.stages()),
            board: [card | board],
            deck: rest
        }
    }
    |> add_action(%{action: :river, msg: "River"})
  end

  def ending(
        table = %{
          game: %{players: players},
          round: %{board: board}
        }
      ) do
    winner = find_winner(players, board)

    %{
      table
      | game: %{
          table.game
          | players: clear_pot(players, winner)
        },
        round: %{
          table.round
          | winner: Player.for_broadcast(winner),
            stage: Round.next_stage(table, TexasHoldEm.stages())
        }
    }
    |> add_action(%{
      action: :winner,
      # "Winner is #{winner.name} with #{
      #   Enum.join(Enum.map(elem(winner.rank, 1), &to_string/1), ", ")
      # }"
      msg: "Winner is #{winner.name}"
      #   Enum.join(Enum.map(elem(winner.rank, 1), &to_string/1), ", ")
      # }"
    })
  end

  def deal_cards(players, [card1, card2 | deck], dealer, index) do
    if mod(dealer - 1, length(players)) == index do
      {deck,
       List.update_at(players, index, fn player -> Map.put(player, :hand, [card1, card2]) end)}
    else
      players
      |> List.update_at(index, fn player -> Map.put(player, :hand, [card1, card2]) end)
      |> deal_cards(deck, dealer, mod(index + 1, length(players)))
    end
  end

  def find_winner(players, board) do
    active_players = Enum.filter(players, &Player.active?/1)

    case length(active_players) do
      1 ->
        List.first(active_players)

      _ ->
        active_players
        |> Enum.map(&%{&1 | rank: Hand.best_combination(board, &1.hand)})
        |> Enum.max_by(& &1.rank)
    end
  end

  def clear_pot(players, winner) do
    winner_bid = winner.bids

    {pot, players} =
      Enum.reduce(players, {0, []}, fn player, {pot, acc} ->
        bid = if player.bids >= winner_bid, do: winner_bid, else: player.bids
        {pot + bid, acc ++ [Map.update!(player, :bids, &(&1 - bid))]}
      end)

    Enum.map(players, fn player ->
      if player.id == winner.id do
        Map.update!(player, :chips, fn chips -> chips + pot end)
      else
        player = Map.update!(player, :chips, fn chips -> chips + player.bids end)

        player =
          Map.update!(player, :status, fn status ->
            if player.chips == 0, do: "out", else: status
          end)

        Map.put(player, :bids, 0)
      end
    end)
  end
end
