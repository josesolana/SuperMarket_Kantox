defmodule DiscountRules do
  @moduledoc "false"
  defstruct [:discount_type, :condition, :value]

  alias Decimal, as: D
  @doc """
    Diferents discount's type(discount_type) could be applied over prices.
    Each type has his own condition and a value in concordance.
    ##Example
    iex> alias Decimal
    iex> price = Decimal.from_float(5.0)
    iex> rule_2_x_1 = %DiscountRules{
    ...>discount_type: :x_get_y,
    ...>condition: 2,
    ...>value: 1,
    ...>}
    iex> DiscountRules.apply_discount(2, price, rule_2_x_1)
    #Decimal<5.0>
    iex> off_10 = Decimal.from_float(4.5 / 5)
    iex> rule_GT_3_33_percent = %DiscountRules{
    ...>discount_type: :drop_if_GT,
    ...>condition: 3,
    ...>value: off_10,
    ...>}
    iex> DiscountRules.apply_discount(5, price, rule_GT_3_33_percent)
    #Decimal<22.50>
  """
  def apply_discount(count, price, %{discount_type: :x_get_y,
                                             condition: condition,
                                             value: value,
                                             }) do
    count # Example: Buy 3(X), Get 2(Y) |  count = 5
    |> div(condition) # Divide count by X Value: div(5 , 3) = 1
    |> (&((&1 * value))).() # Multiple by Y value: 1 * 2 = 2
    |> (&(&1 + rem(count, condition))).() # Finally add the Remainder: 2 + rem(5 , 2) = 4
    |> D.mult(price)
  end

  def apply_discount(count, price, %{discount_type: :drop_if_GT,
                                     condition: condition,
                                     value: value,
                                    })  when count >= condition do
    price
    |> D.mult(value)
    |> D.mult(count)
  end

  def apply_discount(count, price, _) do
    D.mult(count, price)
  end
end
