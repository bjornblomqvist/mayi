# MayI

A plugable access rights API. Meant to make integrations easier. Verry useful as an integration point for blog,forum and CMS components. Also its much nicer to read than the basic stuff i usually do.

An example basic way to do rights handeling

```ruby
if user_object.is_admin?
...
end
```

With mayi this changes to method with an explicit mening to it.

```ruby
access.may_add_user! do
...
end
```




## An example

Your rights implements with boolean questions.

```ruby
class MyAccessHandler

  include MayI
  
  def initialize(user)
    @user = user
  end
  
  def may_view_secret_project(project)
    stuff.owner_id ==  @user.id
  end
  
  def may_create_new_record
    @user.type == "admin"
  end
end
```

This can then be used with the MayI::Access class.


```ruby

access = MyAccessHandler.new(user)

# Simple boolean
if access.may_create_new_record?
  # You do stuff here
end

# With a block
access.may_create_new_record? do
  # You do stuff here
end

# Raise errors on false
access.may_view_secret_project!(project)
# or
access.error_message("A custom error message").may_view_secret_project!(project)

```

## A Rails example

```ruby
class ApplicationController < ActionController::Base

  helper_method :current_user
  def current_user 
    ...
  end
  
  helper_method :access
  def access
    @@access_cache ||= MyAccessHandler.new(current_user)
  end
  
end
```

Check if a user should be able to view some secret stuff.

```ruby
class StuffController < ApplicationController

  def show
    stuff = Stuff.find(params[:id])
    
    access.may_view_secret_stuff?(stuff) do
    
    end
  end
  
end
```


## Contributing to MayI
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Darwin. See LICENSE.txt for
further details.

