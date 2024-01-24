class DropSectorHighLowToStocks < ActiveRecord::Migration[7.1]
  def change
    remove_column :stocks, :sector
    remove_column :stocks, :high
    remove_column :stocks, :low
  end
end
