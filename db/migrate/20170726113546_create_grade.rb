class CreateGrade < ActiveRecord::Migration[5.1]
  def change
    create_table(:grades) do |t|
      t.column(:cat1, :int)
      t.column(:cat2, :int)
      t.column(:cat3, :int)
      t.column(:total, :int)
      t.column(:grade, :string)
      t.column(:position, :int)
      t.column(:comments, :varchar)
      t.timestamps
    end
  end
end
