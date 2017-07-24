class CreateParents < ActiveRecord::Migration[5.1]
  def change
    create_table(:parents) do |t|
      t.column(:name, :varchar, :limit=>50)
      t.column(:phone, :varchar, :limit=>20)
      t.column(:email, :varchar, :limit=>50)
      t.column(:username, :varchar, :limit=>50)
      t.column(:password, :varchar, :limit=>10)

      t.timestamps()
    end
  end
end
