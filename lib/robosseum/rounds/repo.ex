defmodule Robosseum.Rounds.Repo do
  @moduledoc """
  Repository to work with games
  """
  # import Ecto.Query, only: [from: 2]

  alias Robosseum.Repo
  alias Robosseum.Tables
  alias Robosseum.Models.{Table, Game}

  def create(table_id, players) do
    table = Tables.Repo.get!(table_id)

    %Game{}
    |> Game.changeset(%{table_id: table_id, blind: table.config["blind"] , dealer: 0})
    |> Repo.insert!()
  end
end
