defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  # Solo se aplica el plug para validar usuario login en los siguientes defs (excluido el index de esta lista.)
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  # function plug (:check_topic_owner) - es un plug que solo ejecuta una funcion y por lo general solo se usan en un controller.
  plug :check_topic_owner when action in [:update, :edit, :delete]

  # metodo para traer todos los topics de base de datos con Repo.all(Topic)
  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  # redirecciona a show.html para mirar un topic
  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  # este def new apunta a new.html.eex en la carpeta web>templates>topic
  # new es el nombre clave
  def new(conn, _params) do
    # parametros para imprimir y debugear
    # IO.puts "+++++"
    # IO.inspect conn
    # IO.puts "+++++"
    # IO.inspect params
    # IO.puts "+++++"
    changeset = Topic.changeset(%Topic{}, %{})
    ejemplo_envio_parametros = 1 + 1
    render conn, "new.html", changeset: changeset, ejemplo_envio_parametros: ejemplo_envio_parametros
  end

  #  params fue remplezado por %{"topic" => topic} con pattern matching
  def create(conn, %{"topic" => topic}) do
    # params regresa varias cosas, dentro de esas cosas esta "topic" => %{"title" => "asdasdasd"}

    # Cualquiera de las dos sintaxis para obtener valores de conn.assigns es valida:
    # conn.assigns[:user] ó conn.assigns.user

    # Con build_assoc() se liga el nuevo registro de topic con el current user id.
    # changeset = Topic.changeset(%Topic{}, topic)

    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        # render conn, "new.html", changeset: changeset
        conn
        |> put_flash(:error, "Topic can't be blank and needs to be at least 30 characters long.")
        |> render "new.html", changeset: changeset
    end
  end

  #  params fue remplezado por %{"id" => topic_id} con pattern matching
  def edit(conn, %{"id" => topic_id}) do
    # Repo.get(nombreTabla,idRecord) metodo para obtener un record por id de base de datos.
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  # metodo para actualizar el topic con parametros del id del topic a modificar y el nuevo topic string a poner.
  def update(conn, %{"id" => topic_id, "topic" => topic}) do

    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    # misma forma que las dos lineas de codigo de arriba pero con pipe
    # changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    # el ! en los metodos es para mandar un mensaje error de phoenix cuando algo salga mal con algunos de los metodos, por ejemplo que no encuentre el record a eliminar o que por alguna razon no lo pueda eliminar.
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  # params es diferente en este metodo por que es un plug
  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt(  )
    end
  end

end
