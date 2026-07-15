# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Validate RBS signature files (sig/) for syntax and consistency'
task :sig do
  sh 'bundle exec rbs -I sig validate'
end

task default: :spec
