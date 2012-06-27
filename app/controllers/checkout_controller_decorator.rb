CheckoutController.class_eval do
  include AffiliateCredits

  private

  def after_complete
    session[:order_id] = nil

    if current_user && current_user.affiliate_partner
      sender = current_user.partner

      #create credit (if required)
      create_affiliate_credits(sender, current_user, first_order?(current_user) ? "first purchase" : "purchase", @order)
    end
  end

  def first_order?(user)
    user.orders.where(:state => 'complete').count == 1
  end
  
end
