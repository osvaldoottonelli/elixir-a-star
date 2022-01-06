defmodule AstarApp.CLI.Vector2 do
  defstruct x: 0, y: 0

  #euclidean distance
  def distance(u,v) do

    dx = v.x - u.x
    dy = v.y - u.y
    Math.sqrt(dx * dx + dy*dy)

  end
end
