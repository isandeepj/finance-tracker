class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :company_name, :symbol, presence: true

    def image_url
      "https://storage.googleapis.com/iex/api/logos/#{symbol}.png"
    end
    
    def self.new_lookup(ticker_symbol)
      client = IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:publishable_token_key], secret_token: Rails.application.credentials.iex_client[:secret_token_key], endpoint: 'https://api.iex.cloud/v1')      
      begin
        quote = client.quote(ticker_symbol)
        p quote
        new(symbol: ticker_symbol, company_name: quote.company_name, latest_price: quote.latest_price)
      rescue => exception
        p exception  # This will print the exception object to the console
        return nil
      end
    end

    def self.check_db(ticker_symbol)
      where(symbol: ticker_symbol).first
    end

  end