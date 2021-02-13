defmodule Quizzical.Categories.ParamConverter do
  def convert(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> %{id: int}
      _ -> %{name: binary}
    end
  end
end
