Product.class_eval do
  def bonus_credit
    property_id = Spree::Config[:recipient_credit_product_property].to_i
    product_property = ProductProperty.find_by_product_id_and_property_id(id, property_id)
    if product_property
      product_property.value.to_f
    else
      0
    end
  end
end