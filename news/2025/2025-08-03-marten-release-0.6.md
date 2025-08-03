# Marten release: 0.6

We are pleased to announce the release of [Marten 0.6](https://martenframework.com/docs/the-marten-project/release-notes/0.6)!

**Marten 0.6** brings significant enhancements, including localized routes, annotations, array schema fields, and image fields for models and schemas. These features make building apps with Marten smoother and more flexible. For a detailed overview of all new features and changes, check out the [full changelog](https://martenframework.com/docs/the-marten-project/release-notes/0.6).

## New features and highlights

### Localized routes

Marten now provides the ability to define localized routes through the use of two mechanisms: automatically adding locale prefixes to routes and activating the appropriate locale based on the prefix, and translating the routes themselves. These mechanisms can be used independently or in combination.

For example, the following routes map defines routes that will be prefixed by the currently activated locale and whose paths will be translated using the considered project's translations:

```crystal
ARTICLE_ROUTES = Marten::Routing::Map.draw do
  path t("routes.articles.list"), ArticlesHandler, name: "list"
  path t("routes.articles.create"), ArticleCreateHandler, name: "create"
  path t("routes.articles.detail"), ArticleDetailHandler, name: "detail"
  path t("routes.articles.update"), ArticleUpdateHandler, name: "update"
  path t("routes.articles.delete"), ArticleDeleteHandler, name: "delete"
end

Marten.routes.draw do
  localized do
    path t("routes.landing"), LandingPageHandler, name: "landing"
    path t("routes.articles.prefix"), ARTICLE_ROUTES, name: "articles"
  end
end
```

As highlighted above, the use of routes prefixed with locales can be activated by wrapping route paths by a call to the [`#localized`](https://martenframework.com/docs/api/0.6/Marten/Routing/Map.html#localized(prefix_default_locale%3Dtrue%2C%26)%3ANil-instance-method) method. Route path translations can be defined using the [`#t`](https://martenframework.com/docs/api/0.6/Marten/Routing/Map.html#t(path%3AString)%3ATranslatedPath-instance-method) method, which assigns a translation key to each route (this key is then dynamically used to generate the route's path based on the active locale).

With the routes map defined above, generated routes are fully localized and vary based on the currently activated locale:

```crystal

I18n.activate("en")
Marten.routes.reverse("landing")         # => "/en/landing"
Marten.routes.reverse("articles:create") # => "/en/articles/create"

I18n.activate("fr")
Marten.routes.reverse("landing")         # => "/fr/accueil"
Marten.routes.reverse("articles:create") # => "/fr/articles/creer"
```

Please refer to the [Localized routes](https://martenframework.com/docs/i18n/localized-routes) section of the documentation to learn more about this new capability.

### Annotations

Marten now lets you annotate query sets with aggregated data. This is useful when you need to "retain" aggregated values for each record in a query set (possibly for further filtering or for making use of the aggregated values when dealing with individual records). This can be achieved by using the [`#annotate`](https://martenframework.com/docs/models-and-databases/reference/query-set#annotate) method.

For example:

```crystal
# Annotate the query set with the number of articles for each author.
Author.all.annotate { count(:articles) }

# Get all the authors that have more than 10 articles.
Author.all.annotate { count(:articles) }.where(articles_count__gt: 10)

# Order all the authors by the number of articles they have.
Author.all.annotate { count(:articles) }.order(:articles_count)

# Access the annotated values for each author.
authors = Author.all.annotate { count(:articles) }
authors.each do |author|
  puts author.name
  puts author.annotations["articles_count"]
end
```

Please refer to the [Aggregations](https://martenframework.com/docs/models-and-databases/queries#aggregations) section of the documentation to learn more about this new capability.

### Array schema field

Marten now lets you define `array` schema fields that allow validating lists of values, with each value subject to the validation rules of an array member field (such as `string`, `int`, or any other existing [schema field type](https://martenframework.com/docs/schemas/reference/fields)).

For example, the following schema allows validating lists of string values whose sizes must not be greater than 10:

```crystal
class TestSchema < Marten::Schema
  field :values, of: :string, max_size: 10
end
```

As highlighted by the above example, the type of the underlying array member field must be specified through the use of an [`of`](https://martenframework.com/docs/schemas/reference/fields#of) option, which should reference an [existing schema field type](https://martenframework.com/docs/schemas/reference/fields#field-types) (such as `string`, `enum`, etc).

Please refer to the [schema field reference](https://martenframework.com/docs/schemas/reference/fields#array) to learn more about `array` fields.

### Image fields for models and schemas

It is now possible to define `image` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#image) and [schemas](https://martenframework.com/docs/schemas/reference/fields#image), which allow you to store or validate files that are indeed images. This capability requires the use of the [crystal-vips](https://github.com/naqvis/crystal-vips) shard.

For example:

```crystal
class ImageAttachment < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :uploaded_file, :image, blank: false, null: false
end

attachment = ImageAttachment.first!
attachment.uploaded_file            # => #<Marten::DB::Field::File::File:0x102dd0ac0 ...>
attachment.uploaded_file.attached?  # => true
attachment.uploaded_file.name       # => "test.png"
attachment.uploaded_file.size       # => 5796929
attachment.uploaded_file.url        # => "/media/test.png"
```

## Other changes

Marten 0.6 also includes lots of additional changes and quality-of-life improvements. Head over to the [official Marten 0.6 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.6) for a full overview of everything in this release.
