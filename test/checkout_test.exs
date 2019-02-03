defmodule CheckoutTest do
  use ExUnit.Case
  doctest Checkout

  @tests_green {[:GR1, :SR1, :GR1, :GR1, :CF1], Decimal.from_float(22.45)}
  @tests_green_mixed {[:GR1, :GR1], Decimal.from_float(3.11)}
  @tests_strawberry {[:SR1, :SR1, :GR1, :SR1], Decimal.from_float(16.61)}
  @test_coffe {[:GR1, :CF1, :SR1, :CF1, :CF1], Decimal.from_float(30.56)}

  @discount_green_tea {:GR1, %DiscountRules{
                              discount_type: :x_get_y,
                              condition: 2,
                              value: 1,
                             }
                      }

  @discount_strawberry {:SR1, %DiscountRules{
                                discount_type: :drop_if_GT,
                                condition: 3,
                                value: Decimal.from_float(4.5 / 5),
                              }
                        }

  @discount_coffe {:CF1, %DiscountRules{
                            discount_type: :drop_if_GT,
                            condition: 3,
                            value: Decimal.from_float(2 / 3),
                          }
                    }

  test "Test GREEN TEA supermarket discounts" do
    check(@tests_green)
  end

  test "Test GREEN TEA MIXED supermarket discounts" do
    assert check(@tests_green_mixed)
  end

  test "Test STRAWBERRY supermarket discounts" do
    assert check(@tests_strawberry)
  end

  test "Test COFEE supermarket discounts" do
    assert check(@test_coffe)
  end

  test "Test Error Pricing Rules" do
    assert Checkout.new(%{}) == :error
  end

  defp check({prod_list, total_expected}) do
    co = [@discount_coffe|[@discount_strawberry|[@discount_green_tea]]]
         |> Checkout.new

    Enum.each(prod_list, &co.scan/1)
    Decimal.equal?(co.total, total_expected)
  end
end
