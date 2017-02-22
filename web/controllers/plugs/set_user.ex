# Este plug es para encontrar el user_id en la sesion, si se encuentra en la sesion y en base de datos entonces se carga esa info en la conn para ser usado en otras partes del proyecto.
defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # init esta vacio por que en realidad no lo ocupamos, solo se requiere implementar.
  def init(_params) do
  end

  # el params de call se refiere al params que regrese init
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    # condition statement (similar a else if)
    # cond considera cualquier valor diferente de nil y false como true
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      #opcion de default si nada de las opciones de arriba se cumple
      true ->
        assign(conn, :user, nil)
    end
  end

end
