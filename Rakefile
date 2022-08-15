# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

# require "rubocop/rake_task"

# RuboCop::RakeTask.new

desc 'build gem & local install it'
task :preview do
  system("gem build mchat.gemspec && gem install ./mchat-#{Mchat::VERSION}.gem")
end

desc 'build docker images & push'
task :docker_pd do
  system("docker build -t mark24code/mchat:latest .")
  system("docker push mark24code/mchat")
  system("docker build -t mark24code/mchat:#{Mchat::VERSION} .")
  system("docker push mark24code/mchat:#{Mchat::VERSION}")
end

task default: %i[test]
