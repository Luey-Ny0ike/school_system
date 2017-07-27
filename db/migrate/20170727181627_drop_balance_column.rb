class DropBalanceColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column(:fees, :balance, :int)
  end
end
