$: << File.dirname(__FILE__)

require 'spec_helper'
require 'dm-core/spec/adapter_shared_spec'

describe DataMapper::Adapters::RiakAdapter do
  before :all do
    @adapter = DataMapper.setup(:default, :adapter => 'riak')
  end

  it_should_behave_like 'An Adapter'
end