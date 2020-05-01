defmodule Training.Models.Token do
  @db_name Application.get_env(:training, :redb_db)
  @db_table "tokens"

  use Training.Models.Base
  alias Training.DB.Manager

  # Poison Enconder Type
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :type, #activation, reset
    :user,
    :used,
    :expires_at,
    :created_at,
    :updated_at
  ]
end