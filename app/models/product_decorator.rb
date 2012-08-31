Product.class_eval do
  def credit_property_id
    Spree::Config[:recipient_credit_product_property].to_i
  end
  def bonus_credit
    product_property = self.product_properties.where(:property_id => self.credit_property_id).first
    if product_property
      product_property.value.to_f
    else
      0
    end
  end
end