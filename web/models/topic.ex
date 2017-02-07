defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User # belongs_to para relacionar el modelo de topic con user, belongs_to se refiere a que topic tiene 1 liga a users
  end

  # \\ %{} es para indicar si el segundo parametro se manda a llamar como nil, entonces que el valor default sea un map.
  # changeset es para convertir el record de base de datos a estructura que podemos utilizar en el proyecto.
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    # para validar que no este vacio
    |> validate_required([:title])
  end
end
