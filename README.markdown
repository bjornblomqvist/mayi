# MayI

A nice explicit API for access rights handling.

## In short

This is an example from one of my older projects.

```ruby
if user_object.is_admin?
  ...
end
```

With MayI.

```ruby
access.may_add_user! do
  ...
end
```

As you can see with MayI this changes to a nice method call with an explicit mening. I have found this small API to be a big win! Now we have the actually question we wish to have answered documented.


## The API

A basic access rights implementation.

```ruby
class MyAccessHandler

  include MayI
  
  def initialize(user)
    @user = user
  end
  
  def may_view_secret_stuff(stuff)
    stuff.owner_id ==  @user.id
  end
  
  def may_create_new_record
    @user.type == "admin"
  end
end
```

This is how you would it.

```ruby

access = MyAccessHandler.new(user)

# Simple boolean
if access.may_create_new_record?
  ...
end

# With a block
access.may_create_new_record? do
  ...
end

# With erros
access.may_view_secret_stuff!(stuff)
access.may_view_secret_stuff!(stuff) do
  ...
end

# With custom error message
access.error_message("A custom error message").may_view_secret_stuff!(stuff)

```

## With Rails

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

```ruby
class StuffController < ApplicationController

  def show
    stuff = Stuff.find(params[:id])
    
    access.may_view_secret_stuff?(stuff) do
      ...
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

