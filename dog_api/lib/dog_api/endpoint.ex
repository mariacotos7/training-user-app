defmodule Doggos.Endpoint do
  require Logger
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/" do
    {:ok, token_with_default_claims, _ } =
      Doggos.Token.generate_and_sign()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{:token => token_with_default_claims}))
  end

  forward("/dog", to: Doggos.Router)
  forward("/user", to: Doggos.User_Router)

  match _ do
    send_resp(conn, 404, "Page not found!")
  end

end
