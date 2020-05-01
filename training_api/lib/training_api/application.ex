defmodule Training.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
      :ets.new(:my_tokens, [:set, :public, :named_table])
      #{user_id, token}

      Supervisor.start_link(children(), opts())
  end
    defp children do
     [
     {Plug.Adapters.Cowboy2, scheme: :http,
     plug: Training.Endpoint, options: [port: 4000]},

     worker(Training.DB.Manager, [[
       name: Training.DB.Manager,
       host: Application.get_env(:training, :redb_host),
       port: Application.get_env(:training, :redb_port)
     ]]),
     ]
    end

  defp opts do
    [
      strategy: :one_for_one,
      name: Training.Supervisor
    ]
  end
end
