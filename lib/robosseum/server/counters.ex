defmodule Robosseum.Server.Counters do
  @derive Jason.Encoder
  defstruct games: 0,
            rounds: [],
            actions: []
  def new(counters) do
    %__MODULE__{
      games: counters.games,
      rounds: counters.rounds,
      actions: counters.actions
    }
  end


  def new_game(counters) do
    %__MODULE__{
      counters
      | games: counters.games + 1,
        rounds: [0 | counters.rounds],
        actions: [[] | counters.actions]
    }
  end

  def new_round(counters) do
    [current_rounds | rest_rounds] = counters.rounds
    [current_actions | rest_actions] = counters.actions

    %__MODULE__{
      counters
      | rounds: [current_rounds + 1 | rest_rounds],
        actions: [[0 | current_actions] | rest_actions]
    }
  end

  def new_action(counters) do
    [[current_round_actions | rest_round_actions] | rest_actions] = counters.actions

    %__MODULE__{
      counters
      | actions: [[current_round_actions + 1 | rest_round_actions] | rest_actions]
    }
  end

  def current_indexes(counters) do
    game = counters.games
    [round | _rest] = counters.rounds
    [[action | _rest1] | _rest2] = counters.actions

    {game, round, action}
  end
end
