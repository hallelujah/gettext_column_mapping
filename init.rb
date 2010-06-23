# Include hook code here
# HOOK inspired by gettext_i18n_rails
begin
  require 'config/initializers/session_store'
rescue LoadError
  # weird bug, when run with rake rails reports error that session
  # store is not configured, this fixes it somewhat...
end
require_gettext = Proc.new do
  begin
    require 'gettext_i18n_rails'
  rescue Exception => e
    begin
      require 'gettext_rails'
    rescue
      raise "Must implement a gettext backend : gettext_i18n_rails or gettext_rails"
    end
  end
  require 'gettext_column_mapping'
end

if Rails::VERSION::MAJOR > 2
  require_gettext.call
else
  #requires fast_gettext to be present.
  #We give rails a chance to install it using rake gems:install, by loading it later.
  config.after_initialize { require_gettext.call }
end
