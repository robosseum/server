defmodule RobosseumWeb.Dashboard.PlayerController do
  use RobosseumWeb, :controller

  alias Robosseum.Dashboard
  alias Robosseum.Models.Player

  def index(conn, %{"table_id" => table_id}) do
    table = Dashboard.get_table!(table_id)
    players = Dashboard.list_players(table_id)
    render(conn, "index.html", table: table, players: players)
  end

  def new(conn, %{"table_id" => table_id}) do
    table = Dashboard.get_table!(table_id)
    changeset = Dashboard.change_player(%Player{}, %{table_id: table_id})
    IO.inspect changeset
    render(conn, "new.html", table: table, changeset: changeset)
  end

  def create(conn, %{"table_id" => table_id, "player" => player_params}) do
    table = Dashboard.get_table!(table_id)
    case Dashboard.create_player(player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: Routes.dashboard_table_player_path(conn, :index, table))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:alert, IO.inspect changeset.errors)
        |> render("new.html", table: table, changeset: changeset)
    end
  end

  def edit(conn, %{"table_id" => table_id, "id" => id}) do
    table = Dashboard.get_table!(table_id)
    player = Dashboard.get_player!(id)
    changeset = Dashboard.change_player(player)
    render(conn, "edit.html", table: table, player: player, changeset: changeset)
  end

  def update(conn, %{"table_id" => table_id, "id" => id, "player" => player_params}) do
    table = Dashboard.get_table!(table_id)
    player = Dashboard.get_player!(id)

    case Dashboard.update_player(player, player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: Routes.dashboard_table_player_path(conn, :index, table))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", table: table, player: player, changeset: changeset)
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   player = Dashboard.get_player!(id)
  #   {:ok, _player} = Dashboard.delete_player(player)

  #   conn
  #   |> put_flash(:info, "Player deleted successfully.")
  #   |> redirect(to: Routes.dashboard_table_player_path(conn, :index))
  # end
end
