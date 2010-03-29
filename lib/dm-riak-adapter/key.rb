module DataMapper
  module Types
    class Key < Type
      primitive String
      serial    true
    end
  end
end