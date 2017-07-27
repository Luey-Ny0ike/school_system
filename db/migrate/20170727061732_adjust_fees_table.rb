class AdjustFeesTable < ActiveRecord::Migration[5.1]
  def change
    remove_column(:fees, :student_id, :serial)
    add_column(:fees, :student_id, :int)
  end
end
