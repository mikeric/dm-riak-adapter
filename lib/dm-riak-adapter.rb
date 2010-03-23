require 'riak'

module DataMapper::Adapters
  class RiakAdapter < AbstractAdapter
    def initialize(name, options)
      super
      @riak = Riak::Client.new
    end
    
    def create(resources)
      stores = stores_for(resources.first.model)
      
      resources.each {|r| initialize_serial(r, stores.size.succ)}
      create_store(resources)
    end
    
    def read(query)
      query.filter_records(stores_for(query.model).dup)
    end
    
    def update(attributes, collection)
      attributes = attributes_as_fields(attributes)
      
      stores_for(collection.query.model).each {|r| r.update(attributes)}
      update_store(collection)
    end
    
    def delete(collection)
      delete_store(collection)
    end
    
    private
    
    def stores_for(model)
      bucket = @riak[model.storage_name]
      bucket.keys.map {|key| bucket[key].data}
    end
    
    def create_store(resources)
      resources.each do |resource|
        robject = @riak[resource.model.storage_name].new("#{resource.id}").store
        robject.data = resource.attributes(:field)
        robject.store
      end
    end
    
    def update_store(resources)
      resources.each do |resource|
        robject = @riak[resource.model.storage_name]["#{resource.id}"]
        robject.data = resource.attributes(:field)
        robject.store
      end
    end
    
    def delete_store(resources)
      resources.each do |resource|
        @riak[resource.model.storage_name]["#{resource.id}"].delete
      end
    end
  end
  
  const_added(:RiakAdapter)
end