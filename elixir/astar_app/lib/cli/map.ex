#Represents the graph with a matrix (w x h)
#where each cell has

defmodule AstarApp.CLI.Map do

  #defines de map
  def createMapMatrix() do
    %{
      0 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      1 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      2 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      3 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      4 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      5 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      6 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      7 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      8 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costWall(),  6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() },
      9 => %{ 0=>costGrass(), 1=>costGrass(), 2=>costGrass(), 3=>costGrass(), 4=>costGrass(), 5=>costGrass(), 6=>costGrass(), 7=>costGrass(), 8=>costGrass(), 9=>costGrass() }
    }
  end

  def costGrass, do: 1
  def costWater, do: 2
  def costWall,  do: 9
  def mapWidth,  do: 10
  def mapHeight, do: 10

  def printMatrix(nil,  _), do: IO.puts("No path found")
  def printMatrix(path, m), do: printLine(true,m,path,0)

  #print recusively until matrix (row) limit
  defp printLine(false,_,_,_), do: newLine()
  defp printLine(true,m,path,line) do
    printCol(true,m,path,line,0)

    (line < mapHeight() - 1)
    |> printLine(m,path,line+1)
  end

  #print recursively until matrix (col) limit
  defp printCol(false,_,_,_,_), do: newLine()
  defp printCol(true,m,path,line,col) do
    Enum.any?(path, &(&1 == {line,col}))
    |> printElement(m[line][col] ==  costWall())

    (col < mapWidth() - 1)
    |> printCol(m,path,line,col+1)
  end

  #this is the path
  defp printElement(true, _),      do: IO.write(" P ")
  #this is the wall
  defp printElement(false, true),  do: IO.write(" W ")
  #this is ordinary
  defp printElement(false, false), do: IO.write(" . ")

  defp newLine(), do: IO.puts("")


end
