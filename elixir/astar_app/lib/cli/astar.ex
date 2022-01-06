defmodule AstarApp.CLI.Astar do

  @moduledoc """
  Documentation for `AstarApp`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AstarApp.hello()
      :world

      Algorithm
        openList: list of nodes that will be analyzed
        closeList: list of nodes that already been analyzed
        goal = Destination
        g = cost to move from node A to node B: Horizontal/Vertical cost is 10. Diagonal cost is 14 (1 * 10 and 1.4 *10)
        h = (Heuristic - Euclidean distance) distance from destination to current node. Using *10 because we are using g *10 as well
        f = g + h


        add first node in openList

        Repeat:
          current = node from openList with min f

          if current equal goal
            return the path we found
          else
            delete current from openList
            add current node in closeList

            for each current's neighbor that isn't a WALL and isn't in closeList
              if neighbor isn't in openList
                set current as neighbor's parent
                calcule neighbor's G, H and F
                add neighbor in openList
              else
                check if neighbour passing through current node produces a better G
                  recalculed neighbor's G and F
                  set current as neighbor parent

            if openList is empty
              return No path found


  """
  alias AstarApp.CLI.Map
  alias AstarApp.CLI.Node
  alias AstarApp.CLI.Vector2

  def start(m,origin,destiny) do

    first = %Node { row: elem(origin,0),  col: elem(origin,1) }
    goal  = %Node { row: elem(destiny,0), col: elem(destiny,1) }

    openList = [first]
    closeList = []

    search(openList,closeList,goal,m)
    |> Map.printMatrix(m)
  end

  defp search(openList,_,_,_) when length(openList) == 0, do: nil
  defp search(openList,closeList,goal,m) when length(openList) > 0 do
    #find element in openList with min f
    [head | tail ] = openList
    current = findMinF(head,tail)

    #check if we achieve the destination
    if current.row == goal.row and current.col == goal.col do
      findPath(current,[])
    else
      #add current node in closeList
      closeList = closeList ++ [current]
      #remove current element from openList (element with min F)
      List.delete(openList,current)
      |> addNeighbours(closeList,current,goal,m)
      |> search(closeList,goal,m)

    end
  end

  #add all neighbours, checking if can move to each one
  defp addNeighbours(openList,closeList,current,goal,m) do
    addNode(openList,closeList, m, current, goal, -1,-1)
      |> addNode(closeList, m, current, goal,     -1, 0)
      |> addNode(closeList, m, current, goal,     -1, 1)
      |> addNode(closeList, m, current, goal,      0,-1)
      |> addNode(closeList, m, current, goal,      0, 1)
      |> addNode(closeList, m, current, goal,      1,-1)
      |> addNode(closeList, m, current, goal,      1, 0)
      |> addNode(closeList, m, current, goal,      1, 1)
  end

  #check and add One Node (Neighbor) in OpenList
  defp addNode(openList, closeList, m ,current, goal, a, b) do
    r = current.row + a
    c = current.col + b
    newNode = %Node {row: r , col: c, parent: current}
    cond do
      r < 0                               -> openList
      c < 0                               -> openList
      r >= Map.mapHeight()                -> openList
      c >= Map.mapWidth()                 -> openList
      m[r][c] >= Map.costWall()           -> openList
      nodeInList?(closeList,newNode)      -> openList
      #if is in openList than check if g passing through current is less than acutal g
      nodeInList?(openList,newNode)       -> calcGHF(newNode,current,goal)
                                          |> replaceBetterG(openList)
      true                                -> openList ++ [calcGHF(newNode,current,goal)]
    end
  end


  #check if node is already in openList or closeList
  defp nodeInList?(list,node) do
    Enum.any?(list, &(&1.row == node.row and &1.col == node.col))
  end

  #search and replace node in openList when g from newNode (passing trouth current) is less than a cost g already calculated in openList
  defp replaceBetterG(newNode,openList) do
    Enum.map(openList, fn node -> checkBetterG((newNode.row == node.row and newNode.col == node.col and newNode.g < node.g),newNode,node) end)
  end
  defp checkBetterG(true,newNode,_), do: newNode
  defp checkBetterG(false,_,node), do: node

  #calc g, h and f
  #g is the cost to move from parent to node
  #h is estimate cost to goal (using euclidean distance)
  #f = g + h
  defp calcGHF(newNode,current,goal) do
    #horizonta/vertical cost = 10 + parent g, diagonal cost = 14 + parent g
    g1 = calcG(newNode.row != newNode.parent.row and newNode.col != newNode.parent.col, newNode.parent.g)
    g2 = calcG(newNode.row != current.row and newNode.col != current.col, current.g)
    #calcG(node.row != current.row and node.col != current.col, current.g)
    gc = minG((g2 < g1), g2, g1)
    #IO.puts("#{g2} < #{g1} == #{(g2 < g1)}")

    hc = calcH(newNode, goal)
    fc = calcF(gc, hc)
    %{newNode | g: gc, h: hc, f: fc}
  end

  # if true than is diagonal, because node and parent isn't in the same col or row
  defp calcG(true, g), do: 14 + g
  defp calcG(false,g), do: 10 + g
  defp minG(true,g2,_),  do: g2
  defp minG(false,_,g1), do: g1

  #use distance to destiny (*10 to maitain proporcion: we uses 10 to move vertical/horizontal and 14 to move diagonal)
  defp calcH(node,goal) do
    u = %Vector2{x: (node.col+1) * 10, y: (node.row+1) * 10}
    v = %Vector2{x: (goal.col+1) * 10, y: (goal.row+1) * 10}
    Vector2.distance(u,v)
  end

  defp calcF(g, h), do: g + h

  #find min f when we still have recursion to process
  defp findMinF(node,list) when length(list) > 1  do
    [head | tail] = list

    #pass to recursion node whith min f between node and head
    minF(node.f < head.f, node, head)
    |> findMinF(tail)
  end

  #find min f when we have only the last element to check
  defp findMinF(node,list) when length(list) == 1  do
    [head | _] = list
    minF(node.f < head.f, node, head)
  end
  defp findMinF(node,list) when length(list) == 0, do: node

  defp minF(true, node, _),  do: node
  defp minF(false, _, head), do: head

  #the last element
  defp findPath(node, path) when node.parent == nil, do: path ++ [{node.row,node.col}]
  #run trought all path using parent (from destination to origin).
  #to create path in desc order just put next line befor findPath, because starts with destiny
  defp findPath(node, path) when node.parent != nil, do: findPath(node.parent,path) ++ [{node.row,node.col}]

end
