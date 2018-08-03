class Gimoji < ActiveRecord::Base
belongs_to :user
has_many :gimoji_emotions
has_many :emotions, through: :gimoji_emotions



#def gift(user_2)
# if balance>0
#	self.user_id = user_2
#	self.save
#end



end
