# Marten release: 0.5

We are pleased to announce the release of [Marten 0.5](https://martenframework.com/docs/the-marten-project/release-notes/0.5)!

**Marten 0.5** brings significant enhancements, including relations pre-fetching, model scopes, enum fields for models and schemas, and support for raw SQL predicates in query sets. These improvements enhance performance, flexibility, and ease of use. For a detailed overview of all new features and changes, check out the [full changelog](https://martenframework.com/docs/the-marten-project/release-notes/0.5).

## New features and highlights

### Relations pre-fetching

Marten now provides the ability to prefetch relations when using [query sets](https://martenframework.com/docs/models-and-databases/queries.md) through the use of the new [`#prefetch`](https://martenframework.com/docs/models-and-databases/reference/query-set.md#prefetch) method. When using [`#prefetch`](https://martenframework.com/docs/models-and-databases/reference/query-set.md#prefetch), the records corresponding to the specified relationships will be prefetched in single batches and each record returned by the original query set will have the corresponding related objects already selected and populated.

For example:

```crystal
posts_1 = Post.all.to_a
# hits the database to retrieve the related "tags" (many-to-many relation)
puts posts_1[0].tags.to_a

posts_2 = Post.all.prefetch(:tags).to_a
# doesn't hit the database since the related "tags" relation was already prefetched
puts posts_2[0].tags.to_a
```

Like the existing [`#join`](https://martenframework.com/docs/models-and-databases/reference/query-set.md#join) method, this allows to alleviate N+1 issues commonly encountered when accessing related objects. However, unlike [`#join`](https://martenframework.com/docs/models-and-databases/reference/query-set.md#join) (which can only be used with single-valued relationships), [`#prefetch`](https://martenframework.com/docs/models-and-databases/reference/query-set.md#prefetch) can be used with both single-valued relationships and multi-valued relationships (such as [many-to-many](https://martenframework.com/docs/models-and-databases/relationships.md#many-to-many-relationships) relationships, [reverse many-to-many](https://martenframework.com/docs/models-and-databases/relationships.md#backward-relations-2) relationships, and [reverse many-to-one](https://martenframework.com/docs/models-and-databases/relationships.md#backward-relations) relationships).

Please refer to [Pre-fetching relations](https://martenframework.com/docs/models-and-databases/queries.md#pre-fetching-relations) to learn more about this new capability.

### Model scopes

It is now possible to define [scopes](https://martenframework.com/docs/models-and-databases/queries.md#scopes) in model classes. Scopes allow to pre-define specific filtered query sets, which can be easily applied to model classes and model query sets.

Such scopes can be defined through the use of the [`#scope`](https://martenframework.com/docs/api/0.5/Marten/DB/Model/Querying.html#scope(name%2C%26block)-macro) macro, which expects a scope name (string literal or symbol) as first argument and requires a block where the query set filtering logic is defined:

```crystal
class Post < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :title, :string, max_size: 255
  field :is_published, :bool, default: false
  field :created_at, :date_time

  scope :published { filter(is_published: true) }
  scope :unpublished { filter(is_published: false) }
  scope :recent { filter(created_at__gt: 1.year.ago) }
end

Post.published # => Post::QuerySet [...]>
```

It is also possible to override the default scope through the use of the [`#default_scope`](https://martenframework.com/docs/api/0.5/Marten/DB/Model/Querying.html#default_scope-macro) macro. This macro requires a block where the query set filtering logic is defined:

```crystal
class Post < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :title, :string, max_size: 255
  field :is_published, :bool, default: false
  field :created_at, :date_time

  default_scope { filter(is_published: true) }
end
```

Please refer to [Scopes](https://martenframework.com/docs/models-and-databases/queries.md#scopes) for more details on how to define scopes.

### Enum field for models and schemas

It is now possible to define `enum` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields.md#enum) and [schemas](https://martenframework.com/docs/schemas/reference/fields.md#enum). For models, such fields allow you to store valid enum values, with validation enforced at the database level. When validating data with schemas, they allow you to expect valid string values that match those of the configured enum.

For example:

```crystal
enum Category
  NEWS
  BLOG
end

class Article < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :category, :enum, values: Category
end

article = Article.last!
article.category # => Category::BLOG
```

### Raw SQL predicate filtering

Marten now provides the ability to filter [query sets](https://martenframework.com/docs/models-and-databases/queries.md) using [raw SQL predicates](https://martenframework.com/docs/models-and-databases/raw-sql.md#filtering-with-raw-sql-predicates) through the use of the `#filter` method. This is useful when you want to leverage the flexibility of SQL for specific conditions, but still want Marten to handle the column selection and query building for the rest of the query.

For example:

```crystal
Author.filter("first_name = :first_name", first_name: "John")
Author.filter("first_name = ?", "John")
Author.filter { q("first_name = :first_name", first_name: "John") }
```

Please refer to [Filtering with raw SQL predicates](https://martenframework.com/docs/models-and-databases/raw-sql.md#filtering-with-raw-sql-predicates) to learn more about this new capability.

## Other changes

Please head over to the [official Marten 0.5 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.5) for an overview of all the changes that are part of this release.
