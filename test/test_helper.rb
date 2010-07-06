# coding: utf-8
if ENV['GETTEXT']
  require 'gettext_helper'
else
  require 'fast_gettext_helper'
end
require 'test/unit'
require 'active_support/test_case'
class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.expand_path("../db/fixtures",__FILE__)
  self.use_instantiated_fixtures = false
  self.use_transactional_fixtures = true
  set_fixture_class :categories => 'Categorie'
end


