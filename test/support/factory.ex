defmodule Robosseum.Factory do
  alias Robosseum.Repo

  # Factories

  def build(:table) do
    %Robosseum.Models.Table{name: "table"}
  end

  def build(:player) do
    %Robosseum.Models.Player{name: "player"}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
