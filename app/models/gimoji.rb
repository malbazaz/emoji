class Gimoji < ActiveRecord::Base
belongs_to :user
has_many :gimoji_emotions
has_many :emotions, through: :gimoji_emotions
end
