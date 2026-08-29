# Marten release: 0.7

We are pleased to announce the release of [Marten 0.7](https://martenframework.com/docs/the-marten-project/release-notes/0.7)!

**Marten 0.7** brings significant enhancements, including polymorphic relationships, email attachments, field transformations, decimal fields, and template whitespace control. These features make building applications with Marten even more flexible and expressive. For a detailed overview of all new features and changes, check out the [full changelog](https://martenframework.com/docs/the-marten-project/release-notes/0.7).

## New features and highlights

### Polymorphic relationships

Marten now lets you define [`polymorphic`](https://martenframework.com/docs/models-and-databases/reference/fields#polymorphic) model fields. These are useful when you want to store a reference to a record whose model can vary among a predefined set of possible types.

For example:

```crystal
class Article < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :title, :string, max_size: 128
end

class Recipe < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :title, :string, max_size: 128
end

class Comment < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :target, :polymorphic, to: [Article, Recipe], related: :comments, on_delete: :cascade
  field :text, :text
end
```

In the above example, a `Comment` record can be associated with either an `Article` or a `Recipe` record, while both models can expose their associated comments through the corresponding reverse relationship.

Polymorphic fields also generate convenient helper methods and scopes that make it possible to interact with related records in a type-safe manner:

```crystal
article = Article.create!(title: "This is an article")
comment = Comment.create!(text: "This is a comment", target: article)

comment.target      # => #<Article:...>
comment.target_type # => "Article"
comment.target_id   # => 1

comment.target_class  # => Article
comment.target_class! # => Article

comment.article_target? # => true
comment.recipe_target?  # => false

comment.article_target  # => The associated Article record
comment.article_target! # => The associated Article record

Comment.with_article_target
Comment.with_recipe_target
```

Please refer to the [Polymorphic relationships](https://martenframework.com/docs/models-and-databases/relationships#polymorphic-relationships) section of the documentation and the [`Marten::DB::Field::Polymorphic`](https://martenframework.com/docs/api/0.7/Marten/DB/Field/Polymorphic.html) API reference to learn more about this new capability.

### Email attachments

Marten emails can now include attachments through the [`#attach`](https://martenframework.com/docs/api/0.7/Marten/Email.html#attach%28content%3AIO%2Cfilename%3AString%2Cmime_type%3AString%29-instance-method) method.

Files can be attached from paths, existing `File` objects, or arbitrary IOs. This also makes it easy to attach dynamically generated content.

For example:

```crystal
class WelcomeEmail < Marten::Email
  from "no-reply@martenframework.com"
  to @user.email
  subject "Hello!"
  template_name "emails/welcome_email.html"

  before_deliver :add_attachments

  def initialize(@user : User)
  end

  private def add_attachments
    # Attach a file from a path.
    attach "public/docs/terms.pdf"

    # Attach generated content from an IO.
    attach generate_pdf_io(@user),
      filename: "welcome.pdf",
      mime_type: "application/pdf"
  end
end
```

Please refer to the [Defining attachments](https://martenframework.com/docs/emailing#defining-attachments) section of the documentation to learn more about this feature.

### Field transformations

Query sets can now filter date and date/time values using [field transformations](https://martenframework.com/docs/models-and-databases/queries#field-transformations).

These transformations make it possible to extract specific components of a field value directly at the SQL level. `year`, `month`, and `day` transformations can be used with [`date`](https://martenframework.com/docs/models-and-databases/reference/fields#date) and [`date_time`](https://martenframework.com/docs/models-and-databases/reference/fields#date_time) fields, while `hour`, `minute`, and `second` are also available for `date_time` fields.

They can be combined with regular [field predicates](https://martenframework.com/docs/models-and-databases/queries#field-predicates):

```crystal
Article.filter(released_on__year: 2022)

Article.filter(created_at__year__gte: 2022)

Article.filter(created_at__hour__lt: 12)

Article.filter(created_at__month__in: [11, 12])

Article.filter(created_at__year__isnull: false)
```

The transformations are performed by the database itself rather than by loading records and inspecting their values in Crystal.

Please refer to the [field transformations reference](https://martenframework.com/docs/models-and-databases/reference/query-set#field-transformations) for the full list of supported transformations.

### Decimal fields

It is now possible to define [`decimal`](https://martenframework.com/docs/models-and-databases/reference/fields#decimal) model fields in order to persist fixed-precision decimal numbers. These fields map to Crystal's [`BigDecimal`](https://crystal-lang.org/api/BigDecimal.html) values and are particularly useful for monetary amounts and other values that must not lose precision.

Both [`max_digits`](https://martenframework.com/docs/models-and-databases/reference/fields#max_digits) and [`decimal_places`](https://martenframework.com/docs/models-and-databases/reference/fields#decimal_places) must be specified:

```crystal
class Product < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :price, :decimal, max_digits: 10, decimal_places: 2
end

product = Product.create!(price: BigDecimal.new("19.99"))

product.price # => 19.99
```

[`decimal`](https://martenframework.com/docs/schemas/reference/fields#decimal) schema fields are also available for validating incoming data as `BigDecimal` values:

```crystal
class ProductSchema < Marten::Schema
  field :price, :decimal, max_digits: 10, decimal_places: 2
end
```

Please refer to the [model fields reference](https://martenframework.com/docs/models-and-databases/reference/fields#decimal) and [schema fields reference](https://martenframework.com/docs/schemas/reference/fields#decimal) to learn more about `decimal` fields.

### Template whitespace control

The Marten templating language now supports [whitespace control](https://martenframework.com/docs/templates/introduction#whitespace-control) through the use of hyphens in tag, variable, and comment delimiters.

Adding a hyphen (`-`) immediately after an opening delimiter or immediately before a closing delimiter strips the corresponding adjacent whitespace from the rendered output.

For example:

```html
{%- if username == "John Doe" -%}
  Wow, {{ username -}} , you have a long name!
{%- else -%}
  Hello there!
{%- endif %}
```

The above template renders `Wow, John Doe, you have a long name!` when `username` is set to `John Doe`, and `Hello there!` otherwise, without the indentation and extra newlines from the template source.

Please refer to the [Whitespace control](https://martenframework.com/docs/templates/introduction#whitespace-control) section of the documentation for more information.

## Other changes

Marten 0.7 also includes lots of additional changes and quality-of-life improvements. Head over to the [official Marten 0.7 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.7) for a full overview of everything in this release.
