class Location < ActiveRecord::Base
  belongs_to :word
  belongs_to :page
end
