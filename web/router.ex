defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    # pipe_through :browser hace un pre procesamiento de todos los plugs definidos arriba antes de cargar una pagina
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # put "topics/:id", TopicController, :update
    # Con resources "/", TopicController se encapsulan todas las rutas REST asociadas con TopicController, get, post, put y delete, resources asume que se siguio el formato defaul, /topics/new con :new, topics/:id/edit con :edit, etc. Cuando se usa el resources helper el :id que se envia en la ruta siempre se llamara :id, si no se usa el resources entonces se puede modificar el nombre del :id por cualquier otra cosa.
    # resources "/", TopicController
    resources "topics", TopicController
  end

  scope "/auth", Discuss do
    pipe_through :browser
    # :provider se refiere a cualquier provider (facebook, google, github, etc)
    # :request no esta definido en AuthController por que el plug Ueberauth ya lo implementa.
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
