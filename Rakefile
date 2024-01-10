require 'bundler/gem_tasks'
require 'rake/testtask'

task default: "test"

Rake::TestTask.new do |t|
   t.pattern = 'test/**/*_spec.rb'
   t.libs << "test"
   t.libs << "lib"
end
