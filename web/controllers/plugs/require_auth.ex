defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn # para halt()
  import Phoenix.Controller # para put_flash()

  alias Discuss.Router.Helpers # para topic_path()

  # init esta vacio por que en realidad no lo ocupamos, solo se requiere implementar.
  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      # si estan login entonces regresamos la conexion
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt() # halt es para decir a phoenix que este plug ya no hara nada mas.
    end
  end
end
