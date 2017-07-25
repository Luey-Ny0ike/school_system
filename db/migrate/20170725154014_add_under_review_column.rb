class AddUnderReviewColumn < ActiveRecord::Migration[5.1]
  def change
    add_column(:tracks, :under_review, :boolean)
  end
end
