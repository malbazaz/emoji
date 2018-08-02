class CreateGimojiEmotions < ActiveRecord::Migration
  	def change
  	  	create_table :gimoji_emotions do |t|
    		t.integer :gimoji_id
    		t.integer :emotion_id
    	end
  	end
end
