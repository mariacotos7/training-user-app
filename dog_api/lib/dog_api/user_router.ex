defmodule Doggos.User_Router do
    use Plug.Router
  
    import Doggos.Repository
    import Doggos.Dog
    import Doggos.User
    #use Doggos.Auth
    require Logger
  
    plug(Plug.Logger, log: :debug)
  
    plug(:match)
    plug Doggos.AuthPlug
    plug(:dispatch)
  
    get "/" do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!(Doggos.Repository.get_users()))
    end

    get "/signin" do
      {username, password} = {
        Map.get(conn.params, "username", nil),
        Map.get(conn.params, "password", nil)
      }
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Poison.encode!(Doggos.Repository.signin(username,password)))
    end

    post "/" do
        {username, password, role, first_name, last_name, experience} = {
             Map.get(conn.params, "username", nil),
             Map.get(conn.params, "password", nil),
             Map.get(conn.params, "role", nil),
             Map.get(conn.params, "first_name", nil),
             Map.get(conn.params, "last_name", nil),
             Map.get(conn.params, "experience", nil)
           }
    
           cond do
             is_nil(username) ->
               conn
               |> put_status(400)
               |> assign(:jsonapi, %{"error" => "'username' field must be provided"})
             is_nil(password) ->
               conn
               |> put_status(400)
               |> assign(:jsonapi, %{"error" => "'password' field must be provided"})
             is_nil(role) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{"error" => "'role' field must be provided"})
             is_nil(first_name) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{"error" => "'first_name' field must be provided"})
             is_nil(last_name) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{"error" => "'last_name' field must be provided"})
             is_nil(experience) ->
                conn
                |> put_status(400)
                |> assign(:jsonapi, %{"error" => "'experience' field must be provided"})
             true ->
               Doggos.Repository.signup_user(%Doggos.User{
                username: username,
                password: password,
                role: role,
                first_name: first_name,
                last_name: last_name, 
                experience: experience
               })
                   conn
                   |> put_resp_content_type("application/json")
                   |> send_resp(201, Poison.encode!(%{:data => %Doggos.User{
                    username: username,
                    password: password,
                    role: role,
                    first_name: first_name,
                    last_name: last_name, 
                    experience: experience
                   }}))
               end
           end
  
end

  