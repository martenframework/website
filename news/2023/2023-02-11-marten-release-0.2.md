# Marten release: 0.2

We are pleased to announce the release of [Marten 0.2](https://martenframework.com/docs/the-marten-project/release-notes/0.2)!

## New features and highlights


### Authentication

The framework now provides the ability to generate projects with a [built-in authentication system](https://martenframework.com/docs/authentication) that handles basic user management needs: signing in/out users, resetting passwords, etc. This can be achieved through the use of the `--with-auth` option of the [`new`](https://martenframework.com/docs/development/reference/management-commands#new) management command:

```bash
marten new project myblog --with-auth
```

The `--with-auth` option ensures that an `auth` [application](https://martenframework.com/docs/development/applications) is created for the generated project under the `src/auth` folder. This application is part of the created project and provides the necessary [models](https://martenframework.com/docs/models-and-databases), [handlers](https://martenframework.com/docs/handlers-and-http), [schemas](https://martenframework.com/docs/schemas), [emails](https://martenframework.com/docs/emailing), and [templates](https://martenframework.com/docs/templates) allowing authenticating users with email addresses and passwords, while also supporting standard password reset flows. All these abstractions provide a "default" authentication implementation that can be then updated on a per-project basis to better accommodate authentication-related requirements.

### Email sending

Marten now lets you define [emails](https://martenframework.com/docs/emailing) that you can fully customize (properties, header values, etc) and whose bodies (HTML and/or text) are rendered by leveraging [templates](https://martenframework.com/docs/templates). For example, here is how to define a simple email and how to deliver it:

```crystal
class WelcomeEmail < Marten::Email
  to @user.email
  subject "Hello!"
  template_name "emails/welcome_email.html"

  def initialize(@user : User)
  end
end

email = WelcomeEmail.new(user)
email.deliver
```

Emails are delivered by leveraging an [emailing backend mechanism](https://martenframework.com/docs/emailing/introduction#emailing-backends). Emailing backends implement _how_ emails are actually sent and delivered. Presently, Marten supports one built-in [development emailing backend](https://martenframework.com/docs/emailing/reference/backends#development-backend), and a set of other [third-party backends](https://martenframework.com/docs/emailing/reference/backends#other-backends) that you can install depending on your email sending requirements.

Please refer to the [Emailing section](https://martenframework.com/docs/emailing) to learn more about this new feature.

### Raw SQL capabilities

Query sets now provide the ability to perform raw queries that are mapped to actual model instances. This is interesting if the capabilities provided by query sets are not sufficient for the task at hand and you need to write custom SQL queries.

For example:

```crystal
Article.raw("SELECT * FROM articles WHERE title = ?", "Hello World!").each do |article|
  # Do something with `article` record
end
```

Please refer to [Raw SQL](https://martenframework.com/docs/models-and-databases/raw-sql) to learn more about this capability.

### Email field for models and schemas

It is now possible to define `email` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#email) and [schemas](https://martenframework.com/docs/schemas/reference/fields#email). These allow you to easily persist valid email addresses in your models but also to expect valid email addresses in data validated through the use of schemas.

For example:

```crystal
class User < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :email, :email, unique: true
end
```

### Transaction callbacks

Models now support the definition of transaction callbacks by using the [`#after_commit`](https://martenframework.com/docs/models-and-databases/callbacks#aftercommit) and [`#after_rollback`](https://martenframework.com/docs/models-and-databases/callbacks#afterrollback) macros.

For example:

```crystal
class User < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :username, :string, max_size: 64, unique: true

  after_commit :do_something, on: :update

  private def do_something
    # Do something!
  end
end
```

Please refer to [Callbacks](https://martenframework.com/docs/models-and-databases/callbacks) to learn more about this capability.

## Other changes

Please head over to the [official Marten 0.2 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.2) for an overview of all the changes that are part of this release.

