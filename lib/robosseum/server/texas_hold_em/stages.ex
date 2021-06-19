defmodule Robosseum.Server.TexasHoldEm.Stages do
  import Robosseum.Server.Utils

  alias Robosseum.Server.{Table, Round, Player, TexasHoldEm, TexasHoldEm.Hand}

  @doc """
  Deal cards to the players from the deck
  """
  def deal(table = %Table{dealer: dealer, players: players, deck: deck}) do
    {deck, players} = deal_cards(players, deck, dealer)

    %Table{
      table
      | players: players,
        stage: Round.next_stage(table, TexasHoldEm.stages()),
        deck: deck
    }
    |> Table.new_action(%{action: "deal", message: "Deal cards"})
  end

  @doc """
  Burn one card and put 3 cards on the board
  """
  def flop(table = %Table{deck: deck}) do
    [_burn, card1, card2, card3 | rest] = deck

    %Table{
      table
      | stage: Round.next_stage(table, TexasHoldEm.stages()),
        board: [card1, card2, card3],
        deck: rest
    }
    |> Table.new_action(%{action: "flop", message: "Flop"})
  end

  @doc """
  Burn one card and put a card on the board
  """
  def turn(table = %Table{deck: deck, board: board}) do
    [_burn, card | rest] = deck

    %Table{
      table
      | stage: Round.next_stage(table, TexasHoldEm.stages()),
        board: [card | board],
        deck: rest
    }
    |> Table.new_action(%{action: "turn", message: "Turn"})
  end

  @doc """
  Burn one card and put a card on the board
  """
  def river(table = %Table{deck: deck, board: board}) do
    [_burn, card | rest] = deck

    %Table{
      table
      | stage: Round.next_stage(table, TexasHoldEm.stages()),
        board: [card | board],
        deck: rest
    }
    |> Table.new_action(%{action: "river", message: "River"})
  end

  @doc """
  Find winner and clear pot
  """
  def ending(table = %Table{players: players, board: board}) do
    winner = find_winner(players, board)
    players = clear_pot(players, winner)

    %Table{
      table
      | players: players,
        winner: winner,
        stage: Round.next_stage(table, TexasHoldEm.stages())
    }
    |> Table.new_action(%{
      action: "winner",
      # "Winner is #{winner.name} with #{
      #   Enum.join(Enum.map(elem(winner.rank, 1), &to_string/1), ", ")
      # }"
      message: "Winner is #{winner.name}"
      #   Enum.join(Enum.map(elem(winner.rank, 1), &to_string/1), ", ")
      # }"
    })
  end

  @doc """
  Deal two cards to each player [recursive], starting from the dealer
  """
  def deal_cards(players, deck, dealer), do: deal_cards(players, deck, dealer, dealer)

  def deal_cards(players, [card1, card2 | deck], dealer, index) do
    if mod(dealer - 1, length(players)) == index do
      {deck,
       List.update_at(players, index, fn player -> %Player{player | hand: [card1, card2]} end)}
    else
      players
      |> List.update_at(index, fn player -> %Player{player | hand: [card1, card2]} end)
      |> deal_cards(deck, dealer, mod(index + 1, length(players)))
    end
  end

  @doc """
  Find winner among active players
  """
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

  @doc """
  Distrube pot among players
  * when "normal" game -> all pot goes to the winner
  * when an all_in player is winner 
    -> get only as much pot as he bid from other players
    -> other players get the rest back
  """
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

        %Player{player | bids: 0}
      end
    end)
  end
end
