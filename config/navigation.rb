# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>. 
    #
    primary.item :home, 'Home', root_url
    primary.item :store_locations, 'Store Locations', store_locations_path, :highlights_on => /\/(stores\/(\d))|(store_locations)/
    primary.item :about, 'About', about_path
    primary.item :contact, 'Contact', contact_path
    primary.item :privacy, 'Privacy', privacy_path
    
    primary.item :separator1, ''
    primary.item :separator2, 'Control Panel', :if => Proc.new {logged_in?}
    primary.item :admin_dash, 'Admin', admin_dash_path, :if => Proc.new { !current_user.nil? && current_user.role == 'admin' }
    primary.item :mananger_dash, 'Manager', manager_dash_path, :if => Proc.new { !current_user.nil? && current_user.role == 'manager' } do |manager|
      manager.item :manager_shifts, 'Today', manager_shifts_path, :if => Proc.new { !current_user.nil? && current_user.role == 'manager'}
      manager.item :manager_incomplete, 'Incomplete', manager_incomplete_path, :if => Proc.new { !current_user.nil? && current_user.role == 'manager' && has_incomplete_shifts?}
      manager.item :manager_unfilled, 'Unfilled', manager_unfilled_path, :if => Proc.new { !current_user.nil? && current_user.role == 'manager' && has_unfilled_hours?}
    end
    primary.item :employee_dash, 'Employee', employee_dash_path, :highlights_on => /\/employee_dash/, :if => Proc.new { !current_user.nil? && current_user.role == 'employee' }
    
    primary.item :users, 'Users', users_path, :highlights_on => /\/users/, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) }
    primary.item :stores, 'Stores', stores_path, :highlights_on => /\/stores/, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) } do |store|
      store.item :inactive_stores, 'Inactive', inactive_stores_path, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) }
    end  
    primary.item :employees, 'Employees', employees_path, :highlights_on => /\/employees/, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) } do |employee|
      employee.item :inactive_employees, 'Inactive', inactive_employees_path, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) }
    end  
    primary.item :assignments, 'Assignments', assignments_path, :highlights_on => /\/assignments/, :if => Proc.new { !current_user.nil? && current_user.role == 'admin' } do |assignment|
      assignment.item :past_assignments, 'Past', past_assignments_path, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) }
    end
    primary.item :shifts, 'Shifts', shifts_path, :highlights_on => /\/shifts/, :if => Proc.new { !current_user.nil? && %w[admin manager].include?(current_user.role) }
    #primary.item :shift_jobs, 'Shift Jobs', shift_jobs_path, :highlights_on => /\/shift_jobs/, :if => Proc.new { !current_user.nil? && current_user.role == 'admin' }
    primary.item :jobs, 'Jobs', jobs_path, :highlights_on => /\/jobs/, :if => Proc.new { !current_user.nil? && current_user.role == 'admin' } do |job|
      job.item :past_assignments, 'Inactive', inactive_jobs_path, :if => Proc.new { !current_user.nil? && %w[admin].include?(current_user.role) }
    end
  end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    #primary.item :stores, 'Stores', stores_path, :class => 'special', :if => Proc.new { current_user.role? 'admin' }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  #end

end