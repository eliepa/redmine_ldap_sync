# encoding: utf-8
# Copyright (C) 2011-2013  The Redmine LDAP Sync Authors
#
# This file is part of Redmine LDAP Sync.
#
# Redmine LDAP Sync is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Redmine LDAP Sync is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Redmine LDAP Sync.  If not, see <http://www.gnu.org/licenses/>.

# Define namespace and tasks for Rake 7+ compatibility
require 'rake'
require File.expand_path("#{Rails.root}/config/environment")
require Rails.root.join('app/models/application_record.rb')  # Load base model first
require Rails.root.join('app/models/auth_source.rb')        # Load base class first
require Rails.root.join('app/models/auth_source_ldap.rb')   # Then the subclass
require_relative '../ldap_sync/entity_manager'
require_relative '../ldap_sync/infectors/auth_source_ldap'

AuthSourceLdap.include LdapSync::Infectors::AuthSourceLdap unless AuthSourceLdap < LdapSync::Infectors::AuthSourceLdap

namespace :redmine do
  namespace :plugins do
    namespace :ldap_sync do

      desc "Synchronize redmine's users fields and groups with those on LDAP"
      task :sync_users => :environment do
        init_task

        AuthSourceLdap.activate_users! unless ENV['ACTIVATE_USERS'].nil?
        AuthSourceLdap.all.each do |as|
          trace "Synchronizing '#{as.name}' users..."
          as.sync_users
        end
      end

      desc "Synchronize redmine's groups fields with those on LDAP"
      task :sync_groups => :environment do
        init_task

        AuthSourceLdap.all.each do |as|
          trace "Synchronizing '#{as.name}' groups..."
          as.sync_groups
        end
      end

      desc "Synchronize both redmine's users and groups with LDAP"
      task :sync_all => [:sync_groups, :sync_users]

      def init_task
        AuthSourceLdap.running_rake!

        if defined?(ActiveRecord::Base)
          ActiveRecord::Base.logger = Logger.new(STDOUT)
          ActiveRecord::Base.logger.level = Logger::WARN
        end

        if %w(debug error change silent).include? ENV['LOG_LEVEL']
          AuthSourceLdap.trace_level = ENV['LOG_LEVEL'].to_sym
        end

        unless ENV['DRY_RUN'].nil?
          trace "\n!!! Dry-run execution !!!\n"

          User.send :include, LdapSync::DryRun::User
          Group.send :include, LdapSync::DryRun::Group
        end
      end
    end

    def trace(msg)
      return if [:silent, :error, :change].include?(AuthSourceLdap.trace_level)

      puts msg
    end

    namespace :redmine_ldap_sync do
      task :sync_users => 'redmine:plugins:ldap_sync:sync_users'
    end
  end
end