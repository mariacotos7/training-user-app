defmodule Training.Router do
  use Plug.Router

  import Training.Repository
  import Training.Dog
  #use Training.Auth
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug Training.AuthPlug
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(Training.Repository.get_dogs()))
  end


  post "/" do
    {name, age} = {
         Map.get(conn.params, "name", nil),
         Map.get(conn.params, "age", nil)
       }

       cond do
         is_nil(name) ->
           conn
           |> put_status(400)
           |> assign(:jsonapi, %{"error" => "'name' field must be provided"})
         is_nil(age) ->
           conn
           |> put_status(400)
           |> assign(:jsonapi, %{"error" => "'age' field must be provided"})
         true ->
           Training.Repository.add_dog(%Training.Dog{
             name: name,
             age: age
           })
               conn
               |> put_resp_content_type("application/json")
               |> send_resp(201, Poison.encode!(%{:data => %Training.Dog{
                 name: name,
                 age: age
               }}))
           end
       end
end
