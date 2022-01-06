defmodule AstarAppTest do
  use ExUnit.Case
  doctest AstarApp

  test "greets the world" do
    assert AstarApp.hello() == :world
  end
end
