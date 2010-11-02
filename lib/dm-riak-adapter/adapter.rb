require 'pp'
module DataMapper::Adapters
  class RiakAdapter < AbstractAdapter
    # Initializes a new RiakAdapter instance
    # 
    # @param [String, Symbol] name
    #   Repository name
    # 
    # @param [Hash] options
    #   Configuration options
    # 
    # @option options [String] :host ('127.0.0.1') Server hostname
    # @option options [Integer] :port (8098) Server port
    # @option options [String] :prefix ('riak') Path prefix to the HTTP endpoint
    # @option options [String] :namespace ('') Bucket namespace
    def initialize(name, options)
      super
      
      @riak = Riak::Client.new(
        :host   => options[:host],
        :port   => options[:port],
        :prefix => options[:prefix]
      )
      @namespace = options[:namespace] ? options[:namespace] + ':' : ''
    end
    
    # Persists one or many new resources
    # 
    # @example
    #   adapter.create(collection)  # => 1
    # 
    # @param [Enumerable<Resource>] resources
    #   List of resources (model instances) to create
    # 
    # @return [Integer]
    #   Number of objects created
    def create(resources)
      create_objects(resources)
    end
    
    # Reads one or many resources from a datastore
    # 
    # @example
    #   adapter.read(query)  # => [{'title' => 'Lorem Ipsum'}]
    # 
    # @param [Query] query
    #   Query to match objects in the datastore
    # 
    # @return [Enumerable<Hash>]
    #   Array of hashes to become resources
    def read(query)
      query.filter_records(objects_for(query.model)).each do |object|
        query.fields.each do |property|
          object[property.name.to_s] = property.typecast(object[property.name.to_s])
        end
      end
    end
    
    # Updates one or many existing resources
    # 
    # @example
    #   adapter.update(attributes, collection)  # => 1
    # 
    # @param [Hash(Property => Object)] attributes
    #   Hash of attribute values to set, keyed by Property
    # 
    # @param [Collection] collection
    #   Collection of records to be updated
    # 
    # @return [Integer]
    #   Number of records updated
    def update(attributes, collection)
      attributes = attributes_as_fields(attributes)
      
      objects_for(collection.query.model).each {|r| r.update(attributes)}
      update_objects(collection)
    end
    
    # Deletes one or many existing resources
    # 
    # @example
    #   adapter.delete(collection)  # => 1
    # 
    # @param [Collection] collection
    #   Collection of records to be deleted
    # 
    # @return [Integer]
    #   Number of records deleted
    def delete(collection)
      delete_objects(collection)
    end
    
    # Flushes the bucket for the specified model
    # 
    # @example
    #   adapter.flush(Post)  # => ["6moGsRVfutpG4wzibgwDBKc37Dd"]
    # 
    # @param [Class] model
    #   Model to flush
    # 
    # @return [Array<String>]
    #   Keys of the flushed objects
    def flush(model)
      bucket(model).keys.each {|key| bucket(model)[key].delete}
    end
    
    private
    
    def bucket(model)
      @riak.bucket(@namespace + model.storage_name)
    end
    
    def objects_for(model)
      bucket(model).keys.map {|key| bucket(model)[key].data}
    end
    
    def create_objects(resources)
      resources.each do |resource|
        object = bucket(resource.model).new
        object.data = ""
        object.store
        object.instance_variable_set("@_key", object.key)
        initialize_serial(resource, object.key)
        object.instance_variable_set("@_key", object.key)
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def update_objects(resources)
      resources.each do |resource|
        object = bucket(resource.model)[resource.key[0]]
        object.data = resource.attributes(:field)
        object.instance_variable_set("@_key", object.key)
        object.store
      end
    end
    
    def delete_objects(resources)
      resources.each do |resource|
        bucket(resource.model)[resource.key[0]].delete
      end
    end
  end
  
  const_added(:RiakAdapter)
end