# representation
Create different, named representations of a resource for cleaner state representation.
See:  http://en.wikipedia.org/wiki/Representational_State_Transfer#Central_principle

## Install

    gem 'representation'
    bundle

## Usage

```ruby
class User < ActiveRecord::Base 
  representation :public,   :name, :calculated_age
  representation :internal, :name, :ssn, :age

  def calculated_age
    age * 2
  end
end

User.first.representation(:public).inspect
=> #<User name: "Tweedle Dum", calculated_age: 84>

User.first.representation(:internal).inspect
=> #<User name: "Tweedle Dum", age: 42, ssn: "555-55-5555">
````

## Contributing to representation
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Chris Johnson, SocialVibe. See LICENSE.txt for further details.

