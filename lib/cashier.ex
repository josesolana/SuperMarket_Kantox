defmodule Cashier do
  @moduledoc """
    State handler which simulate differents states through a cashier's life:
      * An empty bucket when is initialized.
      * Add registered product to the cart
      * Get the buy total amount, applying a sort of differents discounts, and empting the bucket to start over.
  """
  alias Decimal, as: D
  alias DiscountRules, as: Discount

  def new(products_list) do
    state = fn -> {[], products_list} end
    {:ok, _pid} = Agent.start_link(state, name: __MODULE__)
      __MODULE__
  end

  def scan(product) when is_atom(product) do
    state_add_prod = fn ({item_list, product_list}) ->
                        product
                        |> add_prod(product_list, item_list)
                        |> (&({&1, product_list})).()
                      end

    Agent.update(__MODULE__, state_add_prod)
  end

  def scan(_), do: :error

  def total do
    {item_list, products_list} = pop_state()

    item_list
    |> Enum.reduce(D.from_float(0.0), fn (product, acc) ->
                                        product
                                        |> total(products_list)
                                        |> D.add(acc)
                                      end)
  end

  defp add_prod(product, products_list, item_list) do
     with true <- Keyword.has_key?(products_list, product) do
        Keyword.update(item_list, product, 1, &(&1 + 1))
     else
      _ -> IO.puts("Invalid Product: #{product}")
           item_list
     end
  end

  defp pop_state do
    {item_list, products_list} = Agent.get(__MODULE__, &(&1))
    Agent.update(__MODULE__, fn (_) -> {[], products_list} end)
    {item_list, products_list}
  end

  defp total({product, count}, products_list) do
    products_list
    |> get_in([product])
    |> (&(Discount.apply_discount(count, &1.price, &1.rule))).()
    |> D.round(2, :down)
  end
end
