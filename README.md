# dm-riak-adapter

DataMapper adapter for the Dynamo-inspired key/value store, [Riak](http://riak.basho.com/).

## Install

Requires that you have Riak installed. You can download the latest release [here](http://downloads.basho.com/riak/), or install using [homebrew](http://github.com/mxcl/homebrew):

      brew install riak

Install the **dm-riak-adapter** gem:

      gem install dm-riak-adapter

## Synopsis

Require **dm-core** and **dm-riak-adapter**. Tell DataMapper to use the Riak adapter and set a namespace for your app. This namespace will prefix each bucket like `todo:projects` `todo:tasks`. Skip setting a namespace and the buckets will have no prefix.

      require 'dm-core'
      require 'dm-riak-adapter'
      
      DataMapper.setup :default, :adapter => 'riak', :namespace => 'todo'

Continue defining your models and properties as you normally would. Set a property as type `Key` to use Riak's server-assigned UUIDs.

      class Project
        include DataMapper::Resource
        
        property :id,   Key
        property :name, String
        
        has n, :tasks
      end
      
      class Task
        include DataMapper::Resource
        
        property :id,       Key
        property :summary,  String
        
        belongs_to :project
      end

## Resources

- [GitHub](http://github.com/mikeric/dm-riak-adapter)
- [RubyDoc](http://rubydoc.info/github/mikeric/dm-riak-adapter/master/frames)
- [RubyGems](http://rubygems.org/gems/dm-riak-adapter)