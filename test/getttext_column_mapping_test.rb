require 'helper'
class GettextColumnMappingTest < Test::Unit::TestCase

  def test_config
    assert_instance_of ActiveSupport::OrderedOptions, GettextColumnMapping.config
    GettextColumnMapping.config.mapping_file = File.join($gettext_column_mapping_root, 'config/column_mapping.yml')
    assert_not_nil GettextColumnMapping.config.mapping_file
    assert_instance_of GettextColumnMapping::Mapper, GettextColumnMapping.mapper
  end

end
