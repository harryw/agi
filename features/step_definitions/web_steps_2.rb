# This is a 'real' set of web steps, which would normally live in web_steps.rb, but that file is currently
# the auto-generated cucumber-rails web_steps.rb, containing a large set of very generic and clumsy steps.
# Gradually, we should try to move anything from there we really want to this file, or reimplement the same
# kind of steps here with better language, and eventually the old web_steps.rb can be deleted and replaced
# with this one.

Then /^I should see the following fields on the page:$/ do |table|
  table.hashes.each do |hash|
    case hash['field_type']
    when /text/i
      page.should have_field(hash['field label'])
      page.find(hash['field label'])['type'].should == 'text'
    when /select/i
      page.should have_select(hash['field_label'])
    when /checkbox/i
      page.should have_field(hash['field label'])
      page.find(hash['field label'])['type'].should == 'checkbox'
    end
  end
end
