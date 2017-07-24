class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table(:students) do |t|
      t.column(:name, :varchar, :limit=>50)
      t.column(:level, :int)
      t.column(:stream, :varchar, :limit=>50)
      t.column(:fee, :varchar, :limit=>50)
      t.column(:dormitory, :varchar, :limit=>50)
      t.column(:clubs, :varchar, :limit=>150)
      t.column(:events, :varchar, :limit=>250)

      t.timestamps()
    end
  end
end
