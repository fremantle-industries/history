defmodule History.ProductType do
  use EctoEnum,
    type: :product_type,
    enums: [:spot, :swap, :future, :option]
end
