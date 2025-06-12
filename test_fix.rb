#!/usr/bin/env ruby
# Test script to verify the field mapping fix

# Simulate the LdapSetting class behavior
class MockAuthSourceLdap
  def attr_firstname; 'givenName'; end
  def attr_lastname; 'sn'; end
  def attr_mail; 'mail'; end
end

class TestLdapSetting
  STANDARD_USER_FIELDS = [:firstname, :lastname, :mail]

  def initialize(source)
    @auth_source_ldap = source
    @user_standard_ldap_attrs = STANDARD_USER_FIELDS.each_with_object({}) {|f, h| h[f] = send(f)||'' }
    @user_ldap_attrs = {}
  end

  def firstname; @auth_source_ldap.attr_firstname; end
  def lastname; @auth_source_ldap.attr_lastname; end  
  def mail; @auth_source_ldap.attr_mail; end

  def user_field(ldap_attr)
    ldap_attr = ldap_attr.to_s
    result = @user_standard_ldap_attrs.find {|(k, v)| v.downcase == ldap_attr.downcase }.try(:first)
    result ||= @user_ldap_attrs.find {|(k, v)| v.downcase == ldap_attr.downcase }.try(:first)
  end

  def user_ldap_attrs; @user_ldap_attrs; end
end

# Add the try method for compatibility
class Object
  def try(method, *args)
    if respond_to?(method)
      send(method, *args)
    else
      nil
    end
  end
end

class NilClass
  def try(*args); nil; end
end

# Test the fix
puts "Testing LDAP field mapping fix..."

source = MockAuthSourceLdap.new
setting = TestLdapSetting.new(source)

puts "\nStandard LDAP attributes mapping:"
puts "firstname -> #{setting.firstname}"
puts "lastname -> #{setting.lastname}"  
puts "mail -> #{setting.mail}"

puts "\nTesting user_field method:"
test_cases = [
  ['mail', 'mail'],           # exact match
  ['MAIL', 'mail'],           # case insensitive  
  ['givenName', 'firstname'], # exact match
  ['givenname', 'firstname'], # case insensitive lowercase
  ['GIVENNAME', 'firstname'], # case insensitive uppercase
  ['sn', 'lastname'],         # exact match
  ['SN', 'lastname'],         # case insensitive
  ['invalid', nil]            # no match
]

test_cases.each do |ldap_attr, expected|
  result = setting.user_field(ldap_attr)
  status = result == expected ? "✓" : "✗"
  puts "#{status} user_field('#{ldap_attr}') = #{result.inspect} (expected: #{expected.inspect})"
end

puts "\nAll tests completed!"
