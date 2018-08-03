class Gimoji < ActiveRecord::Base
belongs_to :user
has_many :gimoji_emotions
has_many :emotions, through: :gimoji_emotions

 def slug
    self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(sluggedstring)
    @array1 = []
    self.all.find do |inst|
        inst.slug == sluggedstring
    end
  end

#def gift(user_2)
# if balance>0
#	self.user_id = user_2
#	self.save
#end



end
