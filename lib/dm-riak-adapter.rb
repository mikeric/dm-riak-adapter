require 'riak'

module DataMapper::Adapters
  class RiakAdapter < AbstractAdapter
    def initialize(name, options)
      super
      @riak = Riak::Client.new(:prefix => options[:prefix] || 'riak')
      @namespace = options[:namespace] ? options[:namespace] + ':' : ''
    end
    
    def create(resources)
      objects = objects_for(resources.first.model)
      
      resources.each {|r| initialize_serial(r, objects.size.succ)}
      create_objects(resources)
    end
    
    def read(query)
      query.filter_records(objects_for(query.model).dup)
    end
    
    def update(attributes, collection)
      attributes = attributes_as_fields(attributes)
      
      objects_for(collection.query.model).each {|r| r.update(attributes)}
      update_objects(collection)
    end
    
    def delete(collection)
      delete_objects(collection)
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
        object = bucket(resource.model).new("#{resource.id}")
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def update_objects(resources)
      resources.each do |resource|
        object = bucket(resource.model)["#{resource.id}"]
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def delete_objects(resources)
      resources.each do |resource|
        bucket(resource.model)["#{resource.id}"].delete
      end
    end
  end
  
  const_added(:RiakAdapter)
end