class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table(:subjects) do |t|
      t.column(:name, :varchar)
      t.timestamps
    end
  end
end
