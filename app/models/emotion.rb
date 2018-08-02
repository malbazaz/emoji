class Emotion < ActiveRecord::Base
has_many :gimoji_emotions
has_many :gimojis, through: :gimoji_emotions
has_many :users, through: :gimojis 
end
