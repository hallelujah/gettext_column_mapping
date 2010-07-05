class Rubrique < ActiveRecord::Base
  has_many :categories
end
