require 'rake'
require 'rspec/core/rake_task'

if ENV['ENV'] == 'production'
  ENV['VM'] = nil
else
  ENV['VM'] = '33.33.33.10'
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end
