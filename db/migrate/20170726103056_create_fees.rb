class CreateFees < ActiveRecord::Migration[5.1]
  def change
    create_table(:fees) do |t|
      t.column(:student_id, :serial)
      t.column(:total_fees, :int)
      t.column(:amount_paid, :int)
      t.column(:balance, :int)
      t.column(:settled, :boolean)
      t.column(:due_date, :datetime)
      t.timestamps()
    end
  end
end
