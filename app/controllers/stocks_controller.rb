class StocksController < ApplicationController
    def search
      if params[:stock].present?
        @stock = Stock.new_lookup(params[:stock])
        if @stock
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.update(
                "results",
                partial: "users/result"
              )
            end
          end
        else
          respond_to do |format|
            flash.now[:alert] = "Please enter a valid symbol to search"
            format.turbo_stream do
              render turbo_stream: turbo_stream.update(
                "results",
                partial: "users/result"
              )
            end
          end
        end    
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a symbol to search"
          format.turbo_stream do
            render turbo_stream: turbo_stream.update(
              "results",
              partial: "users/result"
            )
          end
        end
      end
    end
  end