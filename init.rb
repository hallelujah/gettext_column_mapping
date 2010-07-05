# coding: utf-8
# Include hook code here
# HOOK inspired by gettext_i18n_rails
begin
  require 'config/initializers/session_store'
rescue LoadError
  # weird bug, when run with rake rails reports error that session
  # store is not configured, this fixes it somewhat...
end
require 'gettext_column_mapping'
