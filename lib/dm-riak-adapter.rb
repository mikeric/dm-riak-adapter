require 'riak'

module DataMapper::Adapters
  class RiakAdapter < AbstractAdapter
    def initialize(name, options)
      super
      @riak = Riak::Client.new
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
    
    def objects_for(model)
      bucket = @riak[model.storage_name]
      bucket.keys.map {|key| bucket[key].data}
    end
    
    def create_objects(resources)
      resources.each do |resource|
        object = @riak[resource.model.storage_name].new("#{resource.id}")
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def update_objects(resources)
      resources.each do |resource|
        object = @riak[resource.model.storage_name]["#{resource.id}"]
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def delete_objects(resources)
      resources.each do |resource|
        @riak[resource.model.storage_name]["#{resource.id}"].delete
      end
    end
  end
  
  const_added(:RiakAdapter)
end