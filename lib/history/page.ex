defmodule History.Page do
  @spec default_page_number :: non_neg_integer
  def default_page_number, do: 0

  @spec default_page_size :: pos_integer
  def default_page_size, do: 25

  @spec small_page_size :: pos_integer
  def small_page_size, do: 5
end
