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

# Compatibility layer for different Rails versions
if Rails::VERSION::MAJOR >= 6
  # Rails 6+ already has versioned migrations
elsif Rails::VERSION::MAJOR >= 5
  # Rails 5+ has versioned migrations but might need this compatibility
  class ActiveRecord::Migration
    unless defined? self.[]
      # Enables the use of versioned migrations on rails < 6
      def self.[](version)
        self
      end
    end
  end
else
  # Rails 4.2 compatibility
  class ActiveRecord::Migration
    unless defined? self.[]
      # Enables the use of versioned migrations on rails < 5
      def self.[](version)
        self
      end
    end
  end
end