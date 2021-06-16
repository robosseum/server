defmodule Robosseum.Server.Utils do
  def mod(x, y) when x > 0, do: rem(x, y)
  def mod(x, y) when x < 0, do: rem(rem(x, y) + y, y)
  def mod(0, _y), do: 0

  def next_active_player(players, active_player) do
    next = mod(active_player + 1, length(players))

    case Enum.at(players, next).status do
      "folded" -> next_active_player(players, next)
      _ -> next
    end
  end

  def add_action(table, action) do
    %{
      table
      | round: %{
          table.round
          | actions: [
              Map.merge(action, %{state: table}) | table.round.actions
            ]
        }
    }
  end

  # defp for_actions(table),
  #   do: %{
  #     board: Enum.map(table.round.board, &Robosseum.Server.Card.to_string/1),
  #     winner: table.round.winner,
  #     stage: table.round.stage,
  #     pot: table.round.pot,
  #     active_player: table.round.active_player,
  #     players: Enum.map(table.game.players, &Robosseum.Server.Player.for_broadcast/1),
  #     dealer: table.game.dealer
  #   }
end

