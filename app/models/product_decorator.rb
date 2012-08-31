Product.class_eval do
  attr_accessible :bonus_credit

  def credit_property_id
    Spree::Config[:recipient_credit_product_property].to_i
  def bonus_credit
    product_property = ProductProperty.find_by_product_id_and_property_id(id, self.credit_property_id)
    if product_property
      product_property.value.to_f
    else
      0
    end
  end
  def bonus_credit=(value)
    product_property = ProductProperty.find_or_create_by_product_id_and_property_id(
      id, 
      self.credit_property_id
      )
    product_property.value = value.to_f
  end
end