defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    provider = params["provider"]
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true) # configure_session(drop: true) elimina toda la sesion (cookies)
    |>redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id) # Con put_session escribimos en coockies
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  # funcion privada
  defp insert_or_update_user(changeset) do
    # Repo.get_by para obtener 1 record (query).
    # case para saber si se encontro o no.
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        # si se pudo insertar regresa {:ok, struct} o si no {:error, changeset}
        Repo.insert(changeset)
      user ->
        # si se encontro el registro entonces regreso tuple
        {:ok, user}
    end
  end

end
