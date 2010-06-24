require 'helper'
require 'models/utilisateur'
class UtilisateurTest < Test::Unit::TestCase
  def test_column_names
    assert_equal 'Gender', Utilisateur.human_attribute_name('sexe')
    assert_equal 'Gender', Utilisateur.human_attribute_name('sexe')
  end
end

