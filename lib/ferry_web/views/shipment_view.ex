defmodule FerryWeb.ShipmentView do
  use FerryWeb, :view

  def has_shipments?(shipments) do
    length(shipments) > 0
  end

  def items_text(shipment) do
    cond do
      shipment.label != nil -> shipment.label
      shipment.items != nil -> shipment.items
      true -> "There is nothing to describe this shipment yet"
    end
  end
end
