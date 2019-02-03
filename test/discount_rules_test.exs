defmodule DiscountRulesTest do
  use ExUnit.Case
  doctest DiscountRules

  test "Test x_get_y" do
    total_expected = Decimal.from_float(15.0)
    price = Decimal.from_float(5.0)
    rule = %DiscountRules{
      discount_type: :x_get_y,
      condition: 2,
      value: 1,
    }

    5
    |> DiscountRules.apply_discount(price, rule)
    |> Decimal.equal?(total_expected)
    |> assert
  end

  test "Test drop_if_GT" do
    total_expected = Decimal.from_float(22.50)
    price = Decimal.from_float(5.0)
    value = Decimal.from_float(4.5 / 5)
    rule = %DiscountRules{
      discount_type: :drop_if_GT,
      condition: 2,
      value: value,
    }

    5
    |> DiscountRules.apply_discount(price, rule)
    |> Decimal.equal?(total_expected)
    |> assert
  end

  test "Test NO rules" do
    total_expected = Decimal.from_float(25.00)
    price = Decimal.from_float(5.0)
    rule = %DiscountRules{}

    5
    |> DiscountRules.apply_discount(price, rule)
    |> Decimal.equal?(total_expected)
    |> assert
  end
end
