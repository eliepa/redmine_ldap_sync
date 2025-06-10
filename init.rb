require 'redmine'

Redmine::Plugin.register :redmine_ldap_sync do
  name 'Redmine LDAP Sync'
  author 'Ricardo Santos'
  author_url 'https://github.com/thorin'
  description 'Syncs users and groups with ldap'
  url 'https://github.com/thorin/redmine_ldap_sync'
  version '2.1.1.devel'
  requires_redmine :version_or_higher => '6.0.0'

  settings :default => HashWithIndifferentAccess.new()
  menu :admin_menu, :ldap_sync, { :controller => 'ldap_settings', :action => 'index' }, :caption => :label_ldap_synchronization,
                    :html => {:class => 'icon icon-ldap-sync'}
end

# Plugin initialization for Rails 6+/7+ compatibility
# Handle both Zeitwerk and classic autoloading
if Rails.application.config.respond_to?(:after_initialize)
  Rails.application.config.after_initialize do
    begin
      # Get plugin directory
      plugin_dir = File.dirname(__FILE__)
      
      # Load files directly to avoid autoloading issues
      require File.join(plugin_dir, 'lib', 'ldap_sync', 'core_ext')
      require File.join(plugin_dir, 'lib', 'ldap_sync', 'infectors')  
      require File.join(plugin_dir, 'lib', 'ldap_sync', 'hooks')
      
    rescue => e
      # Log error but don't break the initialization
      if defined?(Rails.logger) && Rails.logger
        Rails.logger.error "LDAP Sync plugin initialization error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
      end
      # Re-raise in development to help with debugging
      raise e if Rails.env.development?
    end
  end
else
  # Fallback for older Rails versions
  begin
    require File.join(File.dirname(__FILE__), 'lib', 'ldap_sync', 'core_ext')
    require File.join(File.dirname(__FILE__), 'lib', 'ldap_sync', 'infectors')
    require File.join(File.dirname(__FILE__), 'lib', 'ldap_sync', 'hooks')
  rescue => e
    puts "Warning: LDAP Sync plugin failed to load: #{e.message}"
  end
end
