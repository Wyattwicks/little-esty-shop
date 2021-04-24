class Merchants::BulkDiscountsController < ApplicationController

  def index
    def index
      @merchant = Merchant.find(params[:merchant_id])
      
    end
  end

end
