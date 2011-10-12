module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    # the following are examples using path_to_pickle
    
    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   
      path_to_pickle $1, $2, $3
      
    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}'s destroy page$/
        #rack_test_session_wrapper = Capybara.current_session.driver
         #"/projects/#{model($1).id}/stages/#{model($2).id}/clouds/#{model($3).id}", 
        #url_for(:controller => "clouds", :action => 'destroy', :id => model($3).id, :project_id => model($1).id, :stage_id => model($2).id)

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/
      path_to_pickle $1, $2, $3, :extra => $4                           
      
    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? (.+?) page$/                     
      path_to_pickle $1, $2, :extra => $3                                
    

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page
      

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /the show page for (.+)/  
      polymorphic_path(model($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)