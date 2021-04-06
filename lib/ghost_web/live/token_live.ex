defmodule GhostWeb.TokenLive do
  use GhostWeb, :live_view
  require Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: "")
      |> assign(:tokens, sorted_tokens())
      |> assign(:changeset, Ghost.Token.changeset(%Ghost.Token{}, %{}))

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"token" => token_params}, socket) do
    changeset = Ghost.Token.changeset(%Ghost.Token{}, token_params)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:tokens, sorted_tokens())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  def handle_event("delete", %{"token-id" => token_id}, socket) do
    id = token_id |> String.to_integer()
    %Ghost.Token{id: id} |> Ghost.Repo.delete()

    socket =
      socket
      |> assign(:tokens, sorted_tokens())

    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, tokens: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(tokens: %{}, query: query)}
    end
  end

  defp search(query) do
    if not GhostWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp sorted_tokens do
    Ecto.Query.from(
      t in "tokens",
      order_by: [asc: :name],
      select: [:id, :name, :symbol]
    )
    |> Ghost.Repo.all()
  end
end
