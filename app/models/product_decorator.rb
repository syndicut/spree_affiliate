Product.class_eval do
  def bonus_credit(property)
    if product_property = ProductProperty.find_by_product_id_and_property_id(id, property.id)
      product_property.value.to_f
    else
      0
    end
  end
end