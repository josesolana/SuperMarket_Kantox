defmodule Product do
  @moduledoc "false"
  @enforce_keys [:price]
  defstruct [:price,
             rule: %DiscountRules{}]
end

defmodule Checkout do
  @moduledoc """
  Documentation for Checkout for KANTOX by José Solana.
  """

  @doc """
    You are the lead programmer for a small chain of supermarkets. You are required to make a simple
    cashier function that adds products to a cart and displays the total price.
    You have the following test products registered:
    ------------------------------------
    | Product |   code Name  |  Price  |
    |----------------------------------|
    |   GR1   |   Green tea  |  £3.11  |
    |   SR1   | Strawberries |  £5.00  |
    |   CF1   |   Coffee     |  £11.23 |
    ------------------------------------

    ## Special conditions:

    ● The CEO is a big fan of buy-one-get-one-free offers and of green tea. He wants us to add a
    rule to do this.
    ● The COO, though, likes low prices and wants people buying strawberries to get a price
    discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
    ● The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
    to two thirds of the original price.
    Our check-out can scan items in any order, and because the CEO and COO change their minds
    often, it needs to be flexible regarding our pricing rules.

    Our check-out can scan items in any order, and because the CEO and COO change their minds
    often, it needs to be flexible regarding our pricing rules.
    The interface to our checkout looks like this (shown in ruby):

    co = Checkout.new(pricing_rules)
    co.scan(item)
    co.scan(item)
    price = co.total

    ## Examples
    iex> Checkout.new(%{})
    :error
    iex> rule = %DiscountRules{discount_type: :x_get_y,
    ...>condition: 2,
    ...>value: 1,
    ...>}
    iex> Checkout.new([{:GR1, rule}])
    Cashier
  """
  alias Decimal, as: D

  @products_list [
    {:GR1, %Product{
      price: D.from_float(3.11),
          }
    },
    {:SR1, %Product{
      price: D.from_float(5.00),
          }
    },
    {:CF1, %Product{
      price: D.from_float(11.23),
          }
    },
  ]

  def new(pricing_rules \\ [])
  def new(p_r) when is_list(p_r), do: new(@products_list, p_r)
  def new(_), do: :error

  defp new(prod_discount, []), do: Cashier.new(prod_discount)
  defp new(prod_discount, [{prod, %DiscountRules{} = rule}|tail]) do
    prod_discount
    |> Keyword.update!(prod, &(%{&1 | rule: rule}))
    |> new(tail)
  end
  defp new(_, _), do: :error
end
