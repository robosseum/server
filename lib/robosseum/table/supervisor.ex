defmodule Robosseum.Table.Supervisor do
  # use DynamicSupervisor

  # def start_link([]) do
  #   DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  # end

  # def start_child(table_id) do
  #   child_spec = %{
  #     id: Robosseum.Table,
  #     start: {Robosseum.Table, :start_link, [table_id]}
  #   }

  #   DynamicSupervisor.start_child(__MODULE__, child_spec)
  # end

  # def terminate_child(table_id) do
  #   pid = GenServer.whereis(Robosseum.Table.via_tuple(table_id))
  #   DynamicSupervisor.terminate_child(__MODULE__, pid)
  # end

  # def init(:ok) do
  #   DynamicSupervisor.init(strategy: :one_for_one)
  # end
end
