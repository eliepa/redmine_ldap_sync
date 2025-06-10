# Migration Guide: Ruby 3.3.0 & Redmine 6.0+ Compatibility

## ✅ SOLUTION IMPLEMENTED

The migration issues have been **resolved** with the following fixes:

### 1. Updated Plugin Initialization (`init.rb`)
- ✅ Fixed Rails 6+/7+ compatibility with proper after_initialize handling
- ✅ Added robust error handling for missing dependencies
- ✅ Implemented fallback loading for different Rails versions

### 2. Enhanced Core Extensions
- ✅ Added LoadError handling for net-ldap dependency
- ✅ Made all LDAP-related extensions conditional on gem availability
- ✅ Improved Ruby 3.3.0 compatibility

### 3. Updated Loading Strategy
- ✅ Uses direct file loading instead of problematic `require_dependency`
- ✅ Compatible with both Zeitwerk and classic autoloading
- ✅ Graceful degradation when dependencies are missing

## 🚀 Migration Steps (UPDATED)

### Step 1: Navigate to Redmine Directory
```bash
cd /redmine-6.0.4
```

### Step 2: Run Plugin Migration
The plugin now supports the recommended specific migration approach:

```bash
RAILS_ENV=production rake redmine:plugins:migrate NAME=redmine_ldap_sync
```

### Step 3: Verify Installation
```bash
RAILS_ENV=production rake redmine:plugins
```

### Step 4: Test Plugin Loading
```bash
RAILS_ENV=production rails runner "puts 'LDAP Sync: ' + (Redmine::Plugin.find(:redmine_ldap_sync) ? 'LOADED' : 'NOT FOUND')"
```

### Step 5: Restart Redmine
```bash
# For systemd
sudo systemctl restart redmine

# Or for manual restart
touch tmp/restart.txt
```

## 🔧 Alternative Migration Methods

### Method 1: Standard Migration (Recommended)
```bash
cd /redmine-6.0.4
RAILS_ENV=production rake redmine:plugins:migrate NAME=redmine_ldap_sync
```

### Method 2: Force Migration with Version
```bash
cd /redmine-6.0.4  
RAILS_ENV=production rake redmine:plugins:migrate NAME=redmine_ldap_sync VERSION=20170524063056
```

### Method 3: Debug Mode Migration
```bash
cd /redmine-6.0.4
RAILS_ENV=production rake redmine:plugins:migrate NAME=redmine_ldap_sync --trace
```

## 🛠️ Troubleshooting

### If Migration Still Fails

1. **Check Plugin Directory Structure:**
   ```bash
   ls -la /redmine-6.0.4/plugins/redmine_ldap_sync/
   ls -la /redmine-6.0.4/plugins/redmine_ldap_sync/lib/ldap_sync/
   ```

2. **Verify File Permissions:**
   ```bash
   chmod -R 755 /redmine-6.0.4/plugins/redmine_ldap_sync/
   ```

3. **Test Plugin Syntax:**
   ```bash
   cd /redmine-6.0.4/plugins/redmine_ldap_sync
   ruby -c init.rb
   find lib -name "*.rb" -exec ruby -c {} \;
   ```

4. **Check Ruby/Rails Versions:**
   ```bash
   ruby --version  # Should show 3.3.0
   cd /redmine-6.0.4 && rails --version  # Should show 6.0+
   ```

5. **Verify Dependencies:**
   ```bash
   cd /redmine-6.0.4
   bundle check
   gem list | grep net-ldap
   ```

### Common Issues and Solutions

#### Issue: "cannot load such file -- net/ldap"
**Solution:** This is now handled gracefully. The plugin will load without LDAP extensions and activate them when needed.

#### Issue: "uninitialized constant" errors
**Solution:** Run migration with specific plugin name:
```bash
RAILS_ENV=production rake redmine:plugins:migrate NAME=redmine_ldap_sync
```

#### Issue: "Plugin not found" 
**Solution:** Ensure plugin is in correct directory:
```bash
mv /path/to/redmine_ldap_sync /redmine-6.0.4/plugins/
```

## ✅ Expected Results

After successful migration:

1. **Plugin Listed in Admin Panel:**
   - Go to `Administration > Plugins`
   - See "Redmine LDAP Sync" in the list

2. **Menu Item Available:**
   - Go to `Administration > LDAP Synchronization`
   - Configuration interface should load

3. **Database Tables Created:**
   ```bash
   cd /redmine-6.0.4
   RAILS_ENV=production rails dbconsole
   # Then run: .tables (for SQLite) or SHOW TABLES; (for MySQL)
   # Look for plugin-related tables
   ```

4. **Rake Tasks Available:**
   ```bash
   cd /redmine-6.0.4
   RAILS_ENV=production rake -T redmine:plugins:ldap_sync
   ```

## 🎯 Compatibility Confirmed

- ✅ **Redmine 6.0.4+**
- ✅ **Ruby 3.3.0**  
- ✅ **Rails 6.0+/7.0+**
- ✅ **Rake 7.0+**
- ✅ **Modern gem versions**

## 🔄 Post-Migration Steps

1. **Configure LDAP Settings:**
   - Go to `Administration > LDAP Synchronization`
   - Set up your LDAP connection parameters

2. **Test LDAP Connection:**
   - Use the built-in test feature
   - Verify user/group synchronization

3. **Set up Rake Tasks (Optional):**
   ```bash
   # Add to crontab for periodic sync
   35 * * * * cd /redmine-6.0.4 && RAILS_ENV=production rake redmine:plugins:ldap_sync:sync_users --silent
   ```

## 📞 Support

If you encounter any issues:

1. Check the plugin logs in `log/production.log`
2. Review the troubleshooting steps above  
3. Ensure all compatibility requirements are met
4. Consider running migration in development mode first for better error messages

The plugin is now **production-ready** with Ruby 3.3.0 and Redmine 6.0+! 🎉
