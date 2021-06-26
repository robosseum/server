defmodule Robosseum.Server.Table do
  @derive Jason.Encoder

  import Robosseum.Server.Utils

  alias Robosseum.Server.{Repo, Supervisor, Table, Player, TexasHoldEm, Counters, Card}

  defstruct [
    :id,
    :name,
    :blind,
    :deck,
    :stage,
    :active_player,
    :winner,
    counters: %Counters{},
    players: [],
    dealer: 0,
    pot: 0,
    board: [],
    stop: true
  ]

  def new(table) do
    %__MODULE__{
      id: table.id,
      name: table.name,
      stop: table.stop,
      players: table.players,
      counters: Counters.new(table.counters)
    }
  end

  def new_from_action_state(state) do
    new_state = struct(__MODULE__, atomize_keys(state))
    %__MODULE__{
      new_state
      | players: Enum.map(new_state.players, fn player -> struct(Player, player) end),
        counters: struct(Counters, new_state.counters),
        deck: Enum.map(new_state.deck, fn card -> struct(Card, card) end)
    }
  end

  def get_table(table_id) do
    table_id
    |> Repo.get_table_with_preloads()
    |> new()
  end

  def restore_state(table_id) do
    latest_action = Repo.get_latest_action(table_id)
    if latest_action do
      new_from_action_state(latest_action.state)
    else
      get_table(table_id)
    end
  end

  @doc """
  Rebuilds the supervision tree of all tables from the database. Called on Robosseum application start.
  """
  def restore_all() do
    tables = Repo.list_tables()

    Enum.each(tables, fn table ->
      Supervisor.start_child(table.id) |> IO.inspect(label: "RESTORE ALL")
    end)
  end

  @doc """
  Deletes all games then creates a new game
  """
  def restart(%Table{} = table) do
    Repo.delete_actions(table.id)
    counters = %Counters{}
    Repo.update_table(table.id, %{counters: Map.from_struct(counters)})
    get_table(table.id)
  end

  @doc """
  Creates a new game with game players
  """
  def new_game(%Table{id: table_id, players: players, counters: counters} = table) do
    table_model = Repo.get_table(table_id)

    players =
      Enum.map(players, fn player ->
        %Player{
          Player.new(player)
          | chips: table_model.config["chips"]
        }
      end)

    counters = Counters.new_game(counters)

    Repo.update_table(table_id, %{counters: Map.from_struct(counters)})

    %Table{
      table
      | counters: counters,
        players: players,
        dealer: 0,
        blind: table_model.config["blind"]
    }
  end

  def new_round(%Table{id: table_id, dealer: dealer, counters: counters} = table) do
    counters = Counters.new_round(counters)

    Repo.update_table(table_id, %{counters: Map.from_struct(counters)})

    %{
      table
      | counters: counters,
        board: [],
        deck: Robosseum.Server.Deck.new(),
        pot: 0,
        active_player: dealer + 1,
        stage: ["blinds", "normal"]
    }
  end

  # first is for skipping database in testing
  def new_action(table = %Table{id: nil}, _), do: table
  def new_action(table = %Table{id: table_id, counters: counters}, %{action: action, message: message}) do
    counters = Counters.new_action(counters)
    Repo.update_table(table_id, %{counters: Map.from_struct(counters)})
    {game, round, index} = Counters.current_indexes(counters)

    Repo.create_action(%{
      table_id: table_id,
      action: action,
      message: message,
      state: table,
      game: game,
      round: round,
      index: index
    })

    %{
      table
      | counters: counters,
    }
  end

  def run_stage(table = %Table{stage: stage}), do: TexasHoldEm.run_stage(stage, table)

  def bid(table, _player_id, amount) do
    table = TexasHoldEm.Bids.bid(table, amount)
    TexasHoldEm.next_stage(table)
  end

  def fold(table, _player_id) do
    table = TexasHoldEm.Bids.fold(table)
    TexasHoldEm.next_stage(table)
  end
end
