defmodule RobosseumWeb.Dashboard.PlayersControllerTest do
  use RobosseumWeb.ConnCase

  alias Robosseum.Dashboard

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:players) do
    {:ok, players} = Dashboard.create_players(@create_attrs)
    players
  end

  describe "index" do
    test "lists all players", %{conn: conn} do
      conn = get(conn, Routes.dashboard_table_player_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Players"
    end
  end

  describe "new players" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.dashboard_table_player_path(conn, :new))
      assert html_response(conn, 200) =~ "New Players"
    end
  end

  describe "create players" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.dashboard_table_player_path(conn, :create), players: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.dashboard_table_player_path(conn, :show, id)

      conn = get(conn, Routes.dashboard_table_player_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Players"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dashboard_table_player_path(conn, :create), players: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Players"
    end
  end

  describe "edit players" do
    setup [:create_players]

    test "renders form for editing chosen players", %{conn: conn, players: players} do
      conn = get(conn, Routes.dashboard_table_player_path(conn, :edit, players))
      assert html_response(conn, 200) =~ "Edit Players"
    end
  end

  describe "update players" do
    setup [:create_players]

    test "redirects when data is valid", %{conn: conn, players: players} do
      conn = put(conn, Routes.dashboard_table_player_path(conn, :update, players), players: @update_attrs)
      assert redirected_to(conn) == Routes.dashboard_table_player_path(conn, :show, players)

      conn = get(conn, Routes.dashboard_table_player_path(conn, :show, players))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, players: players} do
      conn = put(conn, Routes.dashboard_table_player_path(conn, :update, players), players: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Players"
    end
  end

  describe "delete players" do
    setup [:create_players]

    test "deletes chosen players", %{conn: conn, players: players} do
      conn = delete(conn, Routes.dashboard_table_player_path(conn, :delete, players))
      assert redirected_to(conn) == Routes.dashboard_table_player_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.dashboard_table_player_path(conn, :show, players))
      end
    end
  end

  defp create_players(_) do
    players = fixture(:players)
    %{players: players}
  end
end
