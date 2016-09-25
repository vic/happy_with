defmodule HappyWith do

  @doc ~S"""
  Rewrites the given block and else clauses into Elixir's standard `with` form.

    iex> import HappyWith
    iex> happy_with do
    ...>   {:ok, name} <- {:ok, "joSE"}
    ...>   lower = String.downcase(name)
    ...>   lower
    ...> end
    "jose"


  You can also provide else clauses to the `with` form.


    iex> import HappyWith
    iex> happy_with do
    ...>   {:ok, name} <- {:error, :nobody}
    ...>   _never_reached = String.downcase(name)
    ...> else
    ...>   {:error, _} -> "luis"
    ...> end
    "luis"


  """
  defmacro happy_with([do: {:__block__, _, body}, else: elses]), do: rewrite(body, elses)
  defmacro happy_with([do: {:__block__, _, body}]), do: rewrite(body, nil)

  defp rewrite(body, elses) when length(body) > 1 do
    exprs = Enum.slice(body, 0..-2)
    do_last = [do: Enum.at(body, -1)]
    else_clauses = elses && [else: elses] || []
    {:with, [], exprs ++ [do_last ++ else_clauses]}
  end

  defp rewrite(body, _elses), do: body

end
