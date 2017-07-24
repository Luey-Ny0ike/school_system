class CreateAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table(:associations) do |t|
      t.column(:parent_id, :int)
      t.column(:student_id, :int)

      t.timestamps()
    end
  end
end
