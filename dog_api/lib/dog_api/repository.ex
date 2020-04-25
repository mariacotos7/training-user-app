defmodule Doggos.Repository do

  def add_dog (dog) do
    :ets.insert(:my_dogs, {"dog", dog})
  end

  def get_dogs() do
    :ets.lookup(:my_dogs, "dog")
    |> Enum.map (fn(x) -> elem(x,1) end) 
  end

  def get_users() do
    :ets.lookup(:users, "user")
    |> Enum.map (fn(x) -> elem(x,1) end) 
  end

  def find_user_by_username(username) do
    :ets.lookup(:users, "user")
    |> Enum.filter(fn (x) -> elem(x,1).username == username end)
    |> Enum.map (fn (x) -> elem(x, 1) end)
  end

  def signin(username,password) do
    :ets.lookup(:users, "user")
    |> Enum.filter(fn (x) -> elem(x,1).username == username end)
    |> Enum.filter(fn (x) -> elem(x,1).password == password end)
    |> Enum.map (fn (x) -> elem(x, 1) end)
  end

  def signup_user (user) do
    :ets.insert(:users, {"user", user})
  end

end
