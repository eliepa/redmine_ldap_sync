# plugins/redmine_ldap_sync/init.rb
begin
  require 'sorted_set'
rescue LoadError
  Rails.logger.warn "[redmine_ldap_sync] Please install the 'sorted_set' gem for Ruby 3.2+ compatibility"
end


require 'redmine'
require File.expand_path('lib/ldap_sync/entity_manager', __dir__)


Redmine::Plugin.register :redmine_ldap_sync do
  name 'Redmine LDAP Sync'
  author 'Ricardo Santos'
  author_url 'https://github.com/thorin'
  description 'Syncs users and groups with ldap'
  url 'https://github.com/thorin/redmine_ldap_sync'
  version '2.1.1.devel'
  requires_redmine :version_or_higher => '6.0.0'

  settings default: HashWithIndifferentAccess.new
  menu :admin_menu, :ldap_sync,
       { controller: 'ldap_settings', action: 'index' },
       caption: :label_ldap_synchronization,
       html: { class: 'icon icon-ldap-sync' }
end

# Load and patch immediately (not delayed) to support rake task runtime
begin
  plugin_dir = File.dirname(__FILE__)

  # Load patch modules manually to ensure Zeitwerk doesn't skip them
  require File.join(plugin_dir, 'lib', 'ldap_sync', 'core_ext')
  require File.join(plugin_dir, 'lib', 'ldap_sync', 'infectors')
  require File.join(plugin_dir, 'lib', 'ldap_sync', 'infectors', 'auth_source_ldap')
  require File.join(plugin_dir, 'lib', 'ldap_sync', 'hooks')

  # Ensure monkey patch is applied early
  Rails.configuration.to_prepare do
  require File.join(__dir__, 'lib', 'ldap_sync', 'infectors', 'auth_source_ldap')
  if defined?(AuthSourceLdap) && defined?(LdapSync::Infectors::AuthSourceLdap)
    unless AuthSourceLdap < LdapSync::Infectors::AuthSourceLdap
      AuthSourceLdap.include LdapSync::Infectors::AuthSourceLdap
      Rails.logger.info "[LDAP_SYNC] Patch applied to AuthSourceLdap" if defined?(Rails.logger)
    end
  end
end


rescue => e
  if defined?(Rails.logger) && Rails.logger
    Rails.logger.error "[LDAP_SYNC] Initialization error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
  else
    puts "[LDAP_SYNC] Initialization error: #{e.message}"
  end
  raise e if Rails.env.development?
end
