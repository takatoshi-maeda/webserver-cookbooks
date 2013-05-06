require 'spec_helper'

describe 'nginx' do
  it{ should be_enabled }
  it{ should be_running }
end
