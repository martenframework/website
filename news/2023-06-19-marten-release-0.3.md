# Marten release: 0.3

We are pleased to announce the release of [Marten 0.3](https://martenframework.com/docs/the-marten-project/release-notes/0.3)!

## New features and highlights

### Support for streaming responses

It is now possible to generate streaming responses from iterators of strings easily by leveraging the [`Marten::HTTP::Response::Streaming`](https://martenframework.com/docs/api/0.3/Marten/HTTP/Response/Streaming.html) class or the [`#respond`](https://martenframework.com/docs/api/0.3/Marten/Handlers/Base.html#respond(streamed_content%3AIterator(String)%2Ccontent_type%3DHTTP%3A%3AResponse%3A%3ADEFAULT_CONTENT_TYPE%2Cstatus%3D200)-instance-method) helper method. This can be beneficial if you intend to generate lengthy responses or responses that consume excessive memory (a classic example of this is the generation of large CSV files).

Please refer to [Streaming responses](https://martenframework.com/docs/handlers-and-http/introduction#streaming-responses) to learn more about this new capability.

### Caching

Marten now lets you interact with a global cache store that allows interacting with an underlying cache system and performing basic operations such as fetching cached entries, writing new entries, etc. By using caching, you can save the result of expensive operations so that you don't have to perform them for every request.

The global cache can be accessed by leveraging the [`Marten#cache`](https://martenframework.com/docs/api/0.3/Marten.html#cache%3ACache%3A%3AStore%3A%3ABase-class-method) method. Here are a few examples on how to perform some basic caching operations:

```crystal
# Fetching an entry from the cache.
Marten.cache.fetch("mykey", expires_in: 4.hours) do
  "myvalue"
end

# Reading from the cache.
Marten.cache.read("unknown") # => nil
Marten.cache.read("mykey") # => "myvalue"
Marten.cache.exists?("mykey") => true

# Writing to the cache.
Marten.cache.write("foo", "bar", expires_in: 10.minutes) => true
```

Marten's caching leverages a [cache store mechanism](https://martenframework.com/docs/caching/introduction#configuration-and-cache-stores). By default, Marten uses an in-memory cache (instance of [`Marten::Cache::Store::Memory`](https://martenframework.com/docs/api/0.3/Marten/Cache/Store/Memory.html)) and other [third-party stores](https://martenframework.com/docs/caching/reference/stores#other-stores) can be installed depending on your caching requirements (eg. Memcached, Redis).

Marten's new caching capabilities are not only limited to its standard cache functionality. They can also be effectively utilized via the newly introduced [template fragment caching](https://martenframework.com/docs/caching/introduction#template-fragment-caching) feature, made possible by the [`cache`](https://martenframework.com/docs/templates/reference/tags#cache) template tag. With this feature, specific parts of your [templates](https://martenframework.com/docs/templates) can now be cached with ease.

Please refer to the [Caching](https://martenframework.com/docs/caching) to learn more about these new capabilities.

### JSON field for models and schemas

Marten now provides the ability to define `json` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#json) and [schemas](https://martenframework.com/docs/schemas/reference/fields#json). These fields allow you to easily persist and interact with valid JSON structures that are exposed as [`JSON::Any`](https://crystal-lang.org/api/JSON/Any.html) objects by default.

For example:

```crystal
class MyModel < Marten::Model
  # Other fields...
  field :metadata, :json
end

MyModel.last!.metadata # => JSON::Any object
```

Additionally, it is also possible to specify that JSON values must be deserialized using a class that makes use of [`JSON::Serializable`](https://crystal-lang.org/api/JSON/Serializable.html). This can be done by leveraging the `serializable` option in both [model fields](https://martenframework.com/docs/models-and-databases/reference/fields#json) and [schema fields](https://martenframework.com/docs/schemas/reference/fields#serializable).

For example:

```crystal
class MySerializable
  include JSON::Serializable

  property a : Int32 | Nil
  property b : String | Nil
end

class MyModel < Marten::Model
  # Other fields...
  field :metadata, :json, serializable: MySerializable
end

MyModel.last!.metadata # => MySerializable object
```

### Duration field for models and schemas

It is now possible to define `duration` fields in [models](https://martenframework.com/docs/models-and-databases/reference/fields#duration) and [schemas](https://martenframework.com/docs/schemas/reference/fields#duration). These allow you to easily persist valid durations (that map to [`Time::Span`](https://crystal-lang.org/api/Time/Span.html) objects in Crystal) in your models but also to expect valid durations in data validated through the use of schemas.

For example:

```crystal
class Recipe < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  # Other fields...
  field :fridge_time, :duration, blank: true, null: true
end
```

## Other changes

Please head over to the [official Marten 0.3 release notes](https://martenframework.com/docs/the-marten-project/release-notes/0.3) for an overview of all the changes that are part of this release.
