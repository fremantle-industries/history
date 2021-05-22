defmodule Ghost.Basis do
  alias Ghost.Basis
  alias Ghost.EtsRepo

  def futures do
    Basis.FutureBasis
    |> EtsRepo.all()
  end

  def swap do
    Basis.SwapBasis
    |> EtsRepo.all()
  end

  def hydrate do
    hydrate_futures()
    hydrate_swap()
  end

  defp hydrate_futures do
    :ghost
    |> Application.get_env(:future_basis, [])
    |> Enum.each(fn [spot: spot, future: future] ->
      {spot_venue, spot_product} = spot
      {future_venue, future_product} = future

      {:ok, _} =
        %Basis.FutureBasis{}
        |> Basis.FutureBasis.changeset(%{
          spot_venue: spot_venue |> Atom.to_string(),
          spot_product: spot_product |> Atom.to_string(),
          future_venue: future_venue |> Atom.to_string(),
          future_product: future_product |> Atom.to_string()
        })
        |> EtsRepo.insert()
    end)
  end

  defp hydrate_swap do
    :ghost
    |> Application.get_env(:swap_basis, [])
    |> Enum.each(fn [spot: spot, swap: swap] ->
      {spot_venue, spot_product} = spot
      {swap_venue, swap_product} = swap

      {:ok, _} =
        %Basis.SwapBasis{}
        |> Basis.SwapBasis.changeset(%{
          spot_venue: spot_venue |> Atom.to_string(),
          spot_product: spot_product |> Atom.to_string(),
          swap_venue: swap_venue |> Atom.to_string(),
          swap_product: swap_product |> Atom.to_string()
        })
        |> EtsRepo.insert()
    end)
  end
end
