defmodule HistoryWeb.TokenLive do
  use HistoryWeb, :live_view
  alias History.Tokens
  alias History.Tokens.Token

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign(:tokens, Tokens.all())
      |> assign(:changeset, Token.changeset(%Token{}, %{}))

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"token" => params}, socket) do
    socket =
      with {:ok, token} <- Tokens.insert(params) do
        socket
        |> assign(:tokens, Tokens.all())
        |> assign(:changeset, Token.changeset(token, %{}))
      else
        {:error, changeset} ->
          socket
          |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("delete", %{"token-id" => id}, socket) do
    Tokens.delete(id)
    {:noreply, assign(socket, tokens: Tokens.all())}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, tokens: Tokens.search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case Tokens.search(query) do
      [] ->
        {:noreply,
         socket
         |> assign(tokens: [], query: query)}

      tokens ->
        {:noreply, assign(socket, tokens: tokens, query: query)}
    end
  end
end
