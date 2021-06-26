defmodule RobosseumWeb.TableCounters do
  defstruct [:game, :round, :action, :games, :rounds, :actions]

  def new(counters) do
    game = counters.games
    round = Enum.at(Enum.reverse(counters.rounds), game - 1) || 0
    # actions = Enum.at(Enum.reverse(Enum.at(Enum.reverse(counters.actions), game -1)), round -1)
    %__MODULE__{
      game: game,
      games: game,
      round: round,
      rounds: round
    }
  end
end
