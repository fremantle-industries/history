defmodule HistoryWeb.TokenLive do
  use HistoryWeb, :live_view
  alias History.Tokens

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Tokens.Token.changeset(%Tokens.Token{}, %{}))
      |> assign(query: nil)
      |> assign_tokens()

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"token" => params}, socket) do
    socket =
      with {:ok, token} <- Tokens.insert(params) do
        socket
        |> assign(:changeset, Tokens.Token.changeset(token, %{}))
        |> assign_tokens()
      else
        {:error, changeset} ->
          socket
          |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("delete", %{"token-id" => id}, socket) do
    Tokens.delete(id)
    socket = socket |> assign_tokens()
    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    # {:noreply, assign(socket, tokens: Tokens.search(query), query: query)}

    socket =
      socket
      |> assign(:query, query)
      |> assign_tokens()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign_tokens()

    {:noreply, socket}
  end

  defp assign_tokens(socket) do
    tokens = Tokens.search(socket.assigns.query)

    socket
    |> assign(tokens: tokens)
  end
end
