class User < ActiveRecord::Base
  has_secure_password
  has_many :gimojis
  has_many :emotions, through: :gimojis
  

  def slug
    self.fullname.gsub(" ", "-").downcase
  end

  def self.find_by_slug(sluggedstring)
    @array1 = []
    self.all.find do |inst|
        inst.slug == sluggedstring
    end
  end

end
