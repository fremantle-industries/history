defmodule History.ProductType do
  use EctoEnum,
    type: :product_type,
    enums: [:spot, :swap, :future, :option, :move, :leveraged_token, :bvol, :ibvol, :move]
end
