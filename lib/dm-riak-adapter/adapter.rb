module DataMapper::Adapters
  class RiakAdapter < AbstractAdapter
    def initialize(name, options)
      super
      @riak = Riak::Client.new(:prefix => options[:prefix] || 'riak')
      @namespace = options[:namespace] ? options[:namespace] + ':' : ''
    end
    
    def create(resources)
      create_objects(resources)
    end
    
    def read(query)
      query.filter_records(objects_for(query.model)).each do |object|
        query.fields.each do |property|
          object[property.name.to_s] = property.typecast(object[property.name.to_s])
        end
      end
    end
    
    def update(attributes, collection)
      attributes = attributes_as_fields(attributes)
      
      objects_for(collection.query.model).each {|r| r.update(attributes)}
      update_objects(collection)
    end
    
    def delete(collection)
      delete_objects(collection)
    end
    
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
        object = bucket(resource.model).new.store
        initialize_serial(resource, object.key)
        object.data = resource.attributes(:field)
        object.store
      end
    end
    
    def update_objects(resources)
      resources.each do |resource|
        object = bucket(resource.model)[resource.key[0]]
        object.data = resource.attributes(:field)
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