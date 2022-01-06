defmodule AstarApp do

  @moduledoc """
  Documentation for `AstarApp`.
  """

  @doc """
  AstarApp to search best path to goal.

  ## Examples

      iex> AstarApp.start()
      Print Matrix with path OR path not found

      iex> AstarApp.start({5, 0}, {0, 6})
      {5, 0} == origin
      {0, 6} == goal
      Print Matrix with path OR path not found

  """
  alias AstarApp.CLI.Astar
  alias AstarApp.CLI.Map

  def start(origin,goal) do
    m = Map.createMapMatrix()
    Astar.start(m, origin, goal)

  end
  def start do
    m = Map.createMapMatrix()
    Astar.start(m, {5, 0}, {0, 6})

  end

end
