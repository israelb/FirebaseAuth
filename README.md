## Description

FirebaseAuth is a Rails engine that provides seamless integration with Firebase Authentication for Rails applications. It leverages Firebase's powerful and secure authentication services, allowing you to quickly implement user authentication without compromising security or scalability.

## Motivation

In today's web applications, user authentication is a critical component that requires careful handling of security, scalability, and user experience. While there are many solutions available, Firebase Authentication stands out for its robust security features, ease of integration, and support for multiple authentication providers (email, Google, Facebook, etc.).

However, integrating Firebase Authentication directly into a Rails application can be cumbersome and repetitive. This engine aims to simplify the process by providing a plug-and-play solution that integrates smoothly with Rails, saving developers time and reducing the potential for security vulnerabilities.

By using FirebaseAuth, you benefit from:

- **Enhanced Security**: Leverage Firebase's state-of-the-art security infrastructure.
- **Ease of Integration**: Quickly set up authentication with minimal configuration.
- **Scalability**: Utilize Firebase's infrastructure to handle authentication for applications of any size.
- **Multiple Providers**: Support for various authentication providers out of the box.

FirebaseAuth makes it easy to add secure and scalable authentication to your Rails applications, allowing you to focus on building features that matter to your users.


## Configuration

To use this engine, you need to configure your Firebase credentials in your application. Add the following keys to `config/credentials.yml.enc`:

```yaml
firebase:
  api_key: "YOUR_API_KEY"
  auth_domain: "YOUR_AUTH_DOMAIN"
  project_id: "YOUR_PROJECT_ID"
  storage_bucket: "YOUR_STORAGE_BUCKET"
  messaging_sender_id: "YOUR_MESSAGING_SENDER_ID"
  app_id: "YOUR_APP_ID"
```

### Integration Steps

1. **Include the Engine's JavaScript**

  Add the following line to your `manifest.js` to include the engine's JavaScript:

   ```js
   //= link firebase_auth/application.js
   ```

2.	**Import the Engine’s JavaScript**

  Import the engine’s JavaScript in your application.js:

  ```js
  import "firebase_auth/application"
  ```

3.	**Pin the Engine’s JavaScript with Importmap**

  Add the following line to your config/importmap.rb to pin all JavaScript files from the engine:

  ```ruby
  pin_all_from "../firebase_auth/app/assets/javascripts/firebase_auth", under: "firebase_auth"
  ```

4.	**Include the Authentication Module**

  Include the FirebaseAuth::Authentication module in your ApplicationController:

  ```ruby
  class ApplicationController < ActionController::Base
    include FirebaseAuth::Authentication
  end
  ```

5.	**Authenticate Requests in Controllers**

  To authenticate requests in your controllers, use the before_action :authenticate_request filter:

  ```ruby
  class SomeController < ApplicationController
    before_action :authenticate_request

    def some_action
      # Your action logic here
    end
  end
  ```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "firebase_auth"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install firebase_auth
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
