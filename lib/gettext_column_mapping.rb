require 'active_support'
require 'gettext_column_mapping/mapper'

module GettextColumnMapping
  mattr_accessor :config
  mattr_reader :mapper

  self.config = ActiveSupport::OrderedOptions.new
  @@mapper = GettextColumnMapping::Mapper.new

end
