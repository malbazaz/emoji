class CreateGimojis < ActiveRecord::Migration
  def change
  	  create_table :gimojis do |t|
      t.string :name
      t.string :tag
      t.string :emotion_id
      t.integer :user_id
    end
  end
end
