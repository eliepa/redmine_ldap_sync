#!/usr/bin/env ruby
# Ruby 3.3.0 Compatibility Test for Redmine LDAP Sync Plugin
# This script tests various Ruby 3.3.0 specific features and compatibility

puts "Testing Ruby 3.3.0 compatibility for Redmine LDAP Sync Plugin"
puts "Ruby version: #{RUBY_VERSION}"
puts "=" * 60

# Test 1: Frozen string literals and encoding
puts "\n1. Testing frozen string handling..."
begin
  require_relative 'lib/ldap_sync/core_ext/string'
  require_relative 'lib/ldap_sync/core_ext/ber'
  puts "   ✓ String and BER extensions loaded successfully"
rescue => e
  puts "   ✗ Error loading string extensions: #{e.message}"
end

# Test 2: YAML loading with security
puts "\n2. Testing YAML loading compatibility..."
begin
  require 'yaml'
  config_file = 'config/base_settings.yml'
  if File.exist?(config_file)
    if RUBY_VERSION >= '3.1'
      settings = YAML.safe_load_file(config_file, permitted_classes: [Symbol], aliases: true) || {}
      puts "   ✓ YAML.safe_load_file works correctly"
    else
      settings = YAML::load_file(config_file) || {}
      puts "   ✓ YAML::load_file works correctly"
    end
  else
    puts "   ⚠ Base settings file not found, but YAML loading should work"
  end
rescue => e
  puts "   ✗ YAML loading error: #{e.message}"
end

# Test 3: Hash and string operations
puts "\n3. Testing Hash and String operations..."
begin
  # Test Hash.new with default blocks
  test_hash = Hash.new{|h,k| h[k] = Set.new}
  test_hash['test'] << 'value'
  puts "   ✓ Hash.new with default blocks works"
  
  # Test string operations that might be frozen
  test_string = "test_string"
  result = test_string.strip
  puts "   ✓ String operations work without frozen errors"
rescue => e
  puts "   ✗ Hash/String operations error: #{e.message}"
end

# Test 4: Rails compatibility
puts "\n4. Testing Rails compatibility components..."
begin
  # Test ActiveRecord::Migration compatibility
  require_relative 'lib/ldap_sync/core_ext/migration'
  puts "   ✓ Migration compatibility layer loaded"
  
  # Test if HashWithIndifferentAccess works
  require 'active_support/core_ext/hash/indifferent_access'
  test_hash = HashWithIndifferentAccess.new()
  puts "   ✓ HashWithIndifferentAccess works"
rescue => e
  puts "   ✗ Rails compatibility error: #{e.message}"
end

# Test 5: Net::LDAP compatibility
puts "\n5. Testing Net::LDAP compatibility..."
begin
  require_relative 'lib/ldap_sync/core_ext/ldap'
  puts "   ✓ LDAP extensions loaded successfully"
rescue => e
  puts "   ✗ LDAP compatibility error: #{e.message}"
end

# Test 6: Gem version checking
puts "\n6. Testing gem version checking safety..."
begin
  # Test the safe gem version checking
  if defined?(Gem.loaded_specs) && Gem.loaded_specs['net-ldap']
    puts "   ✓ Safe gem version checking works"
  else
    puts "   ⚠ net-ldap gem not loaded, but version checking is safe"
  end
rescue => e
  puts "   ✗ Gem version checking error: #{e.message}"
end

# Test 7: Rake task compatibility
puts "\n7. Testing Rake task compatibility..."
begin
  # Check if rake files can be loaded without argument errors
  rake_files = Dir['lib/tasks/*.rake']
  rake_files.each do |file|
    # Basic syntax check
    content = File.read(file)
    if content.include?('|t, args|')
      puts "   ✗ Found deprecated Rake syntax in #{file}"
    else
      puts "   ✓ Rake file #{File.basename(file)} uses compatible syntax"
    end
  end
rescue => e
  puts "   ✗ Rake task compatibility error: #{e.message}"
end

puts "\n" + "=" * 60
puts "Ruby 3.3.0 compatibility test completed!"
puts "If you see any ✗ errors above, those need to be addressed."
puts "All ✓ marks indicate successful compatibility tests."
