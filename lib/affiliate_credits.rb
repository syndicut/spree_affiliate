module AffiliateCredits
  private

  def create_affiliate_credits(sender, recipient, event, order = nil)
    #check if sender should receive credit on affiliate register
    if sender_credit_amount = Spree::Config["sender_credit_on_#{event}_amount".to_sym] and sender_credit_amount.to_f > 0
      credit = StoreCredit.create(:amount => sender_credit_amount,
                         :remaining_amount => sender_credit_amount,
                         :reason => "Affiliate: #{event}", :user => sender)

      log_event recipient.affiliate_partner, sender, credit, event
    end

    #check if affiliate should recevied credit on sign up
    if recipient_credit_amount = Spree::Config["recipient_credit_on_#{event}_amount".to_sym] and recipient_credit_amount.to_f > 0
      credit = StoreCredit.create(:amount => recipient_credit_amount,
                         :remaining_amount => recipient_credit_amount,
                         :reason => "Affiliate: #{event}", :user => recipient)

      log_event recipient.affiliate_partner, recipient, credit, event
    end

    #check subsequent purchase
    if event == 'subsequent_purchase' and sender_credit_percent = Spree::Config["sender_credit_percent"]
      for product in order.products
        if recipient_credit_amount = product.bonus_credit and recipient_credit_amount > 0
           credit = StoreCredit.create(:amount => recipient_credit_amount,
                         :remaining_amount => recipient_credit_amount,
                         :reason => "Affiliate: #{event}", :user => recipient)

           log_event recipient.affiliate_partner, recipient, credit, event

           if sender_credit_percent.to_f > 0
            sender_credit_amount = recipient_credit_amount*(sender_credit_percent.to_f/100)                        
            credit = StoreCredit.create(:amount => sender_credit_amount,
                         :remaining_amount => sender_credit_amount,
                         :reason => "Affiliate: #{event}", :user => sender)

            log_event recipient.affiliate_partner, sender, credit, event

            if sender.partner
              partner_credit_amount = sender_credit_amount*(sender_credit_percent.to_f/100)
              credit = StoreCredit.create(:amount => partner_credit_amount,
                           :remaining_amount => partner_credit_amount,
                           :reason => "2-nd level affiliate: #{event}", :user => sender.partner)

              log_event recipient.affiliate_partner, sender, credit, event
            end
          end
        end
      end
    end
  end

  def log_event(affiliate, user, credit, event)
    affiliate.events.create(:reward => credit, :name => event, :user => user)
  end

end
