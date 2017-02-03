defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  # metodo para traer todos los topics de base de datos con Repo.all(Topic)
  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
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
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        # render conn, "new.html", changeset: changeset
        conn
        |> put_flash(:error, "Topic can't be blank.")
        |> render "new.html", changeset: changeset
    end
  end

end
