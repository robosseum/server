defmodule Robosseum.DashboardTest do
  use Robosseum.DataCase

  alias Robosseum.Dashboard

  describe "tables" do
    alias Robosseum.Dashboard.Table

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def table_fixture(attrs \\ %{}) do
      {:ok, table} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dashboard.create_table()

      table
    end

    test "list_tables/0 returns all tables" do
      table = table_fixture()
      assert Dashboard.list_tables() == [table]
    end

    test "get_table!/1 returns the table with given id" do
      table = table_fixture()
      assert Dashboard.get_table!(table.id) == table
    end

    test "create_table/1 with valid data creates a table" do
      assert {:ok, %Table{} = table} = Dashboard.create_table(@valid_attrs)
    end

    test "create_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_table(@invalid_attrs)
    end

    test "update_table/2 with valid data updates the table" do
      table = table_fixture()
      assert {:ok, %Table{} = table} = Dashboard.update_table(table, @update_attrs)
    end

    test "update_table/2 with invalid data returns error changeset" do
      table = table_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_table(table, @invalid_attrs)
      assert table == Dashboard.get_table!(table.id)
    end

    test "delete_table/1 deletes the table" do
      table = table_fixture()
      assert {:ok, %Table{}} = Dashboard.delete_table(table)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_table!(table.id) end
    end

    test "change_table/1 returns a table changeset" do
      table = table_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_table(table)
    end
  end
end
