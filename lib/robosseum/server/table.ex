defmodule Robosseum.Server.Table do
  @derive Jason.Encoder
  alias Robosseum.Server.{Repo, Supervisor, Table, Player, TexasHoldEm}

  defstruct [
    :id,
    :name,
    :game_id,
    :round_id,
    :players,
    :dealer,
    :blind,
    :board,
    :pot,
    :deck,
    :stage,
    :active_player,
    :winner,
    stop: true
  ]

  def new(table) do
    %__MODULE__{
      id: table.id,
      stop: table.stop
    }
  end

  def get_table(table_id) do
    table_id
    |> Repo.get_table_with_preloads()
    |> new()
  end

  @doc """
  Creates a table. A database record and a process.
  """
  def create(name) do
    table = Repo.create_table(name)
    Supervisor.start_child(table.id)
    table
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
    Repo.delete_games(table.id)
  end

  @doc """
  Creates a new game with game players
  """
  def new_game(%Table{} = table) do
    table_model = Repo.get_table_with_preloads(table.id)
    game = Repo.create_game(table_model)

    players =
      Enum.map(table_model.players, fn player ->
        Repo.update_player(player.id, %{
          chips: table_model.config["chips"],
          status: "active",
          to_call: 0
        })
        |> Player.new()
      end)

    %Table{table | game_id: game.id, players: players, dealer: game.dealer, blind: game.blind}
  end

  def new_round(table = %Table{game_id: game_id}) do
    game_model = Repo.get_game(game_id)
    round = Repo.create_round(game_model)

    %{
      table
      | round_id: round.id,
        board: round.board,
        deck: round.deck,
        pot: round.pot,
        active_player: round.active_player,
        stage: round.stage
    }
  end

  def new_action(table = %Table{round_id: nil}, _), do: table
  def new_action(table = %Table{}, %{action: action, message: message}) do
    Repo.create_round_action(table, action, message)

    table
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
