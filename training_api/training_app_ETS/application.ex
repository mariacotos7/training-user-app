defmodule Training.Application do
  use Application

  def start(_type, _args) do
      :ets.new(:my_dogs, [:bag, :public, :named_table])
      :ets.new(:users, [:bag, :public, :named_table])

      Supervisor.start_link(children(), opts())
  end
    defp children do
     [
     {Plug.Adapters.Cowboy2, scheme: :http,
     plug: Training.Endpoint, options: [port: 4000]}
     ]
    end

  defp opts do
    [
      strategy: :one_for_one,
      name: Training.Supervisor
    ]
  end
end
