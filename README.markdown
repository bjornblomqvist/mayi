= may-i

A plugable access rights api. Ment to make integrations easier.

## Basics

You have a class that implements boolean questions.

```ruby
class MyBasicAccess
  def initialize(data)
    @data = data
  end
  
  def may_view_secret_stuff(stuff)
    stuff.owner_id ==  data[:session][:user_id]
  end
  
  def may_create_new_record
    data[:session][:user_type] == "admin"
  end
end
```

This can then be used with the MayI::Access class.


```ruby
access = MayI::Access.new(MyBasicAccess)

# Simple boolean
if access.may_create_new_record?
  # You do stuff here
end

# With a block
access.may_create_new_record? do
  # You do stuff here
end
```

Now with exceptions. On failure the MayI::AccessDeniedError error is raised.

```ruby
access = MayI::Access.new(MyBasicAccess)

# Simple boolean
if access.may_create_new_record!
  # You do stuff here
end

# With a block
access.may_create_new_record! do
  # You do stuff here
end

# With custom error message
access.error_message("Sorry but you are not allowed to do this!").may_create_new_record! do
  # You do stuff here
end
```






## How one could use it in rails


We give it the data it needs

```ruby
class ApplicationController < ActionController::Base
  before_filter :init_access
  
  def init_access 
    # Refresh with the relevant data for this request
    access.refresh({:session => session})
  end
  
  def access
    @@access_cache
  end
  
  @@access_cache = MayI::Access.new
  @@access_cache.implementation = MyBasicAccess
end
```

And here we use the API

```ruby
class SecretStuffController < ApplicationController

  def show
    stuff = Stuff.find(params[:id])
    access.may_view_secret_stuff?(stuff) do
    
    end
  end
  
end
```


== Contributing to may-i
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Darwin. See LICENSE.txt for
further details.
