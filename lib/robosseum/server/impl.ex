defmodule Robosseum.Server.Impl do
  @moduledoc """
  Implementation of server genserver. API in Robosseum.Server.Table
  """

  use GenServer

  alias Robosseum.Server.Table

  def init(table_id) do
    table = Table.get_table(table_id)
    {:ok, table}
  end

  def handle_call({:state}, _, table), do: {:reply, table, table}
  # def handle_call({:set_state, state}, _, _), do: {:reply, state, state}

  def handle_call({:start}, _, table) do
    Kernel.send(self(), :new_game)

    {:reply, table, table}
  end

  def handle_call({:restart}, _, table) do
    table = Table.restart(table)

    Kernel.send(self(), :new_game)

    {:reply, table, table}
  end

  # def handle_call({:stop}, _, table) do
  #   table = %{
  #     table
  #     | stop: true
  #   }

  #   {:reply, table, table}
  # end

  # def handle_call({:sit, player}, _, table) do
  #   table = Core.sit(table, player)
  #   broadcast_update(table)
  #   {:reply, table, table}
  # end

  # def handle_call({:connect, player_id}, _, table) do
  #   table = Core.connect(table, player_id)
  #   broadcast_update(table)
  #   {:reply, table, table}
  # end

  # def handle_call({:bid, player_id, amount}, _, table) do
  #   # check if active player is bidding player
  #   table = Core.bid(table, player_id, amount)
  #   broadcast_update(table)
  #   Kernel.send(self(), :run_stage)
  #   {:reply, table, table}
  # end

  # def handle_call({:fold, player_id}, _, table) do
  #   # check if active player is bidding player
  #   table = Core.fold(table, player_id)
  #   broadcast_update(table)
  #   Kernel.send(self(), :run_stage)
  #   {:reply, table, table}
  # end

  def handle_info(:new_game, table) do
    table = Table.new_game(table)

    # broadcast_update(table)
    # start new game in 5 minutes
    # Process.send_after(self(), :new_game, 5 * 60 * 1000)
    Kernel.send(self(), :new_round)

    # Robosseum.PubSub.update_table(table.id)

    {:noreply, table}
  end

  def handle_info(:new_round, table) do
    table = Table.new_round(table)

    # Robosseum.PubSub.update_game(table.game.id)

    Kernel.send(self(), :run_stage)
    {:noreply, table}
  end

  def handle_info(:run_stage, table = %Table{stage: stage}) do
    table =
      case stage do
        [_, "bid"] ->
          # push_player_bid(table)
          table

        _ ->
          table = Table.run_stage(table)

          # broadcast_update(table)

          if !table.stop do
            Kernel.send(self(), :run_stage)
          end

          table
      end

    {:noreply, table}
  end

  # defp push_player_bid(
  #        table = %{
  #          game: %{players: players},
  #          round: %{active_player: active_player, pot: pot, board: board, stage: stage}
  #        }
  #      ) do
  #   player_to_bid = Enum.at(players, active_player)

  #   Endpoint.broadcast("table:" <> table.id, "bid", %{
  #     board: board,
  #     pot: pot,
  #     stage: stage,
  #     player: player_to_bid
  #   })
  # end
end
