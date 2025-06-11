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
# Ruby 3.3.0 compatibility - Check if net-ldap gem version requires this fix
module LdapSync
  module CoreExt
    module Ber
      if defined?(Gem.loaded_specs) && 
         Gem.loaded_specs['net-ldap'] && 
         ('0.12.0'..'0.13.0').cover?(Gem.loaded_specs['net-ldap'].version.to_s)
        require 'net/ber'

        class Net::BER::BerIdentifiedString < String
          attr_accessor :ber_identifier

          def initialize args
            super
            current_encoding = encoding
            if current_encoding == Encoding::BINARY
              begin
                force_encoding('UTF-8')
                force_encoding(current_encoding) unless valid_encoding?
              rescue FrozenError
                if frozen?
                  Rails.logger.warn "Cannot modify frozen string in BerIdentifiedString" if defined?(Rails) && Rails.logger
                else
                  raise
                end
              end
            end
          end
        end
      end
    end
  end
end