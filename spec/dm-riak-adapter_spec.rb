$: << File.dirname(__FILE__)

require 'spec_helper'
require 'dm-core/spec/adapter_shared_spec'

describe DataMapper::Adapters::RiakAdapter do
  before :all do
    @adapter = DataMapper.setup(:default, :adapter => 'riak', :namespace => 'test')
  end
  
  after :all do
    @adapter.flush Heffalump
  end

  it_should_behave_like 'An Adapter'
end