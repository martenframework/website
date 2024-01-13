# Marten release: 0.4

We are pleased to announce the release of [Marten 0.4](https://martenframework.com/docs/the-marten-project/release-notes/0.4)!

**Marten 0.4** introduces new and long-awaited features such as generators, facilitating the creation of abstractions and structures within projects while following best practices. Additionally, support for multi-table inheritance was also introduced, as well as new schema handler callbacks and the ability to define URL and slug fields in models and schemas. This update is a major step forward, making web development with Marten more user-friendly and feature-rich. In this light, the 0.4 release is also accompanied by a [RealWorld demo project](https://github.com/martenframework/realworld) to demonstrate a fully-fledged fullstack application built with the framework.

## New features and highlights

### Generators

Marten now provides a generator mechanism that makes it easy to create various abstractions, files, and structures within an existing project. This feature is available through the use of the [`gen`](https://martenframework.com/docs/development/reference/management-commands#gen) management command and facilitates the generation of key components such as [models](https://martenframework.com/docs/models-and-databases/introduction), [schemas](https://martenframework.com/docs/schemas/introduction), [emails](https://martenframework.com/docs/emailing/introduction), or [applications](https://martenframework.com/docs/development/applications). The [authentication application](https://martenframework.com/docs/authentication/introduction) can now also be added easily to existing projects through the use of generators. By leveraging generators, developers can improve their workflow and speed up the development of their Marten projects while following best practices.

Below are highlighted some examples illustrating the use of the [`gen`](https://martenframework.com/docs/development/reference/management-commands#gen) management command:

```sh
# Generate a model in the admin app:
marten gen model User name:string email:string --app admin

# Generate a new TestEmail email in the blog application:
marten gen email TestEmail --app blog

# Add a new 'blogging' application to the current project:
marten gen app blogging

# Add the authentication application to the current project:
margen gen auth
```

You can read more about the generator mechanism in the [dedicated documentation](https://martenframework.com/docs/development/generators). All the available generators are also listed in the [generators reference](https://martenframework.com/docs/development/reference/generators).

### Multi table inheritance

It is now possible to define models that inherit from other concrete models (ie. non-abstract models). In this situation, each model can be used/queried individually and has its own associated database table. The framework automatically defines a set of "links" between each model that uses multi table inheritance and its parent models in order to ensure that the relational structure and inheritance hierarchy are maintained.

For example:

```crystal
class Person < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :first_name, :string, max_size: 100
  field :last_name, :string, max_size: 100
end

class Employee < Person
  field :company_name, :string, max_size: 100
end

employee = Employee.filter(first_name: "John").first!
employee.first_name # => "John"
```

All the fields defined in the `Person` model can be accessed when interacting with records of the `Employee` model (despite the fact that the data itself is stored in distinct tables).

You can read more about this new kind of model inheritance in [Multi table inheritance](https://martenframework.com/docs/models-and-databases/introduction#multi-table-inheritance).

### Schema handler callbacks

Handlers that inherit from the base schema handler - [`Marten::Handlers::Schema`](https://martenframework.com/docs/api/0.4/Marten/Handlers/Schema.html) - or one of its subclasses (such as [`Marten::Handlers::RecordCreate`](https://martenframework.com/docs/api/0.4/Marten/Handlers/RecordCreate.html) or [`Marten::Handlers::RecordUpdate`](https://martenframework.com/docs/api/0.4/Marten/Handlers/RecordUpdate.html)) can now define new kinds of callbacks that allow to easily manipulate the considered [schema](https://martenframework.com/docs/schemas/introduction) instance and to define logic to execute before the schema is validated or after (eg. when the schema validation is successful or failed):

* [`before_schema_validation`](https://martenframework.com/docs/handlers-and-http/callbacks#before_schema_validation)
* [`after_schema_validation`](https://martenframework.com/docs/handlers-and-http/callbacks#after_schema_validation)
* [`after_successful_schema_validation`](https://martenframework.com/docs/handlers-and-http/callbacks#after_successful_schema_validation)
* [`after_failed_schema_validation`](https://martenframework.com/docs/handlers-and-http/callbacks#after_failed_schema_validation)

For example, the [`after_successful_schema_validation`](https://martenframework.com/docs/handlers-and-http/callbacks#after_successful_schema_validation) callback can be used to create a flash message after a schema has been successfully validated:

```crystal
class ArticleCreateHandler < Marten::Handlers::Schema
  success_route_name "home"
  template_name "articles/create.html"
  schema ArticleSchema

  after_successful_schema_validation :generate_success_flash_message

  private def generate_success_flash_message : Nil
    flash[:notice] = "Article successfully created!"
  end
end
```

Please head over to [Schema handler callbacks](https://martenframework.com/docs/handlers-and-http/callbacks#schema-handler-callbacks) to learn more about these new types of callbacks.

### URL field for models and schemas

It is now possible to define `url` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#url) and [schemas](https://martenframework.com/docs/schemas/reference/fields#url). These allow you to easily persist valid URLs in your models but also to expect valid URL values in data validated through the use of schemas.

For example:

```crystal
class User < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :website_url, :url, blank: true, null: true
end
```

### Slug field for models and schemas

It is now possible to define `slug` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#slug) and [schemas](https://martenframework.com/docs/schemas/reference/fields#slug). These allow you to easily persist valid slug values (ie. strings that can only include characters, numbers, dashes, and underscores) in your models but also to expect such values in data validated through the use of schemas.

For example:

```crystal
class User < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :username, :slug
end
```

## Other changes

Please head over to the [official Marten 0.4 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.4) for an overview of all the changes that are part of this release.

## RealWorld application

The Marten 0.4 release is accompanied by a [RealWorld](https://github.com/gothinkster/realworld) demo project: [Marten RealWorld](https://github.com/martenframework/realworld). This project was created to demonstrate a fully-fledged fullstack application built with the framework, including CRUD operations, authentication, routing, pagination, and more.
