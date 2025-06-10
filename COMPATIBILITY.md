# Redmine LDAP Sync - Compatibility Guide

## Redmine 6+ and Rails 6+ Compatibility

This plugin has been updated to be compatible with:

- **Redmine 6.0+**
- **Rails 6.0+** 
- **Ruby 3.0+**
- **Rake 7.0+**

## Key Changes Made for Compatibility

### 1. Plugin Initialization
- Updated `RedmineApp::Application` to `Rails.application` for Rails 6+ compatibility
- Updated minimum Redmine version requirement to 6.0.0

### 2. Migration Compatibility
- Updated migration classes to use `ActiveRecord::Migration[6.0]`
- Added compatibility layer for different Rails versions in `lib/ldap_sync/core_ext/migration.rb`

### 3. Controller Updates
- Updated CSRF protection for modern Rails
- Replaced deprecated `skip_before_action` patterns

### 4. Test Infrastructure
- Updated Capybara and Selenium WebDriver configuration
- Replaced PhantomJS with headless Chrome
- Updated test gems for Ruby 3.0+ compatibility

### 5. Rake Task Compatibility
- Removed deprecated task argument patterns for Rake 7+ compatibility
- Updated task definitions to use modern syntax

### 6. CI Configuration
- Updated Ruby versions (3.0, 3.1, 3.2)
- Updated Redmine target versions (6.0-stable, master)
- Updated database adapter to mysql2 with utf8mb4 encoding

## Migration Path

### From Older Versions
1. Ensure you're running Ruby 3.0+ and Redmine 6.0+
2. Update your Gemfile to include compatible test dependencies if running tests
3. Run database migrations: `bundle exec rake redmine:plugins:migrate NAME=redmine_ldap_sync`

### Backward Compatibility
- This version maintains compatibility with existing LDAP configurations
- Database migrations are compatible with existing data
- No configuration changes required for existing installations

## Testing
To run tests with the new configuration:

```bash
# Unit tests
bundle exec rake redmine:plugins:ldap_sync:test:units

# Functional tests  
bundle exec rake redmine:plugins:ldap_sync:test:functionals

# Integration tests
bundle exec rake redmine:plugins:ldap_sync:test:integration

# UI tests (requires Chrome)
bundle exec rake redmine:plugins:ldap_sync:test:ui

# All tests
bundle exec rake redmine:plugins:ldap_sync:test
```

## Dependencies
- Ruby 3.0+
- Rails 6.0+
- Redmine 6.0+
- MySQL 8.0+ or PostgreSQL 12+ (for utf8mb4 support)
- Chrome/Chromium (for UI tests)
