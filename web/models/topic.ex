defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
  end

  # \\ %{} es para indicar si el segundo parametro se manda a llamar como nil, entonces que el valor default sea un map.
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    # para validar que no este vacio
    |> validate_required([:title])
  end
end