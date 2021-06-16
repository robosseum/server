defmodule Robosseum.PubSub do
  def update_table(table_id) do
    Phoenix.PubSub.broadcast(
      __MODULE__,
      "table" <> table_id,
      { "update_table", table_id }
    )
  end
end
