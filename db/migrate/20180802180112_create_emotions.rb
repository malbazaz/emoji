class CreateEmotions < ActiveRecord::Migration
  def change
  	  	create_table :emotions do |t|
      		t.string :name
    	end
  end
end
