# lib/ldap_sync/core_ext/auth_source_ldap.rb

module LdapSync
  module CoreExt
    module AuthSourceLdap
      def self.running_rake!
        @running_rake = true
      end

      def self.running_rake?
        @running_rake == true
      end

      def self.trace_level
        @trace_level ||= 0
      end

      def self.trace_level=(value)
        Rails.logger.info "[LDAP_SYNC] trace_level set to #{value}"
        @trace_level = value
      end
    end
  end
end

# Include the patch into the actual class
::AuthSourceLdap.extend LdapSync::CoreExt::AuthSourceLdap
  

