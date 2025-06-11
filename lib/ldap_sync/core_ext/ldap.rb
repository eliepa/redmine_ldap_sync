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

module LdapSync
  module CoreExt
    module Ldap
      begin
        require 'net/ldap'

        class ::Net::LDAP
          # Ruby 3.3.0 compatibility - Check if gem is available before version check
          if defined?(Gem.loaded_specs) && 
             Gem.loaded_specs['net-ldap'] && 
             Gem.loaded_specs['net-ldap'].version < Gem::Version.new('0.12.0')
            Error = ::LdapError
          end
        end
      rescue LoadError
        # net-ldap gem not available during initialization - this is OK
        # The gem will be loaded when actually needed
      end
    end
  end
end
