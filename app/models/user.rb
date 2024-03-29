class User < ApplicationRecord
  has_many :user_stocks, dependent: :destroy
  has_many :stocks, through: :user_stocks
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Check if a stock with the given ticker symbol is already tracked by the user.
  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    stock.present? && stocks.exists?(stock.id)
  end
  
  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence || 'Anonymous'
  end

  def self.search(param)
    param.strip!
    to_send_back = first_name_matches(param) + last_name_matches(param) + email_matches(param)
    to_send_back.uniq.compact
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} LIKE ?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(id_of_friend)
    !friends.exists?(id: id_of_friend)
  end
end