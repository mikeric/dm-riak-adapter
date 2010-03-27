module DataMapper
  module Types
    class Serial < Type
      primitive String
      serial    true
    end
  end
end