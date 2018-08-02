defmodule Identicon do
  import IEx
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello()
      :world

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  defp hash_input(input) do
    hex =
      :crypto.hash(:md5, input) |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  defp pick_color(%Identicon.Image{ hex: [r, g, b | _tail] } = image) do
    %Identicon.Image{ image | color: { r, g, b } }
  end

  defp build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.flat_map(fn (row) -> mirror_row(row) end)
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  defp mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  defp filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    odd_grid =
      grid
      |> Enum.filter(fn ({code, _index}) -> rem(code, 2) == 0 end)

    %Identicon.Image{image | grid: odd_grid}
  end
end
