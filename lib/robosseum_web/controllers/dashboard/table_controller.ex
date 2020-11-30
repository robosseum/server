defmodule RobosseumWeb.Dashboard.TableController do
  use RobosseumWeb, :controller

  alias Robosseum.Dashboard
  alias Robosseum.Models.Table

  def index(conn, _params) do
    tables = Dashboard.list_tables()
    render(conn, "index.html", tables: tables)
  end

  def new(conn, _params) do
    changeset = Dashboard.change_table(%Table{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"table" => table_params}) do
    case Dashboard.create_table(table_params) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table created successfully.")
        |> redirect(to: Routes.dashboard_table_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    table = Dashboard.get_table!(id)
    changeset = Dashboard.change_table(table)
    render(conn, "edit.html", table: table, changeset: changeset)
  end

  def update(conn, %{"id" => id, "table" => table_params}) do
    table = Dashboard.get_table!(id)

    case Dashboard.update_table(table, table_params) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table updated successfully.")
        |> redirect(to: Routes.dashboard_table_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", table: table, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    table = Dashboard.get_table!(id)
    {:ok, _table} = Dashboard.delete_table(table)

    conn
    |> put_flash(:info, "Table deleted successfully.")
    |> redirect(to: Routes.dashboard_table_path(conn, :index))
  end
end
