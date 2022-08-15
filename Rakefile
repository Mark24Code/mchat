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

Rake::TestTask.new(:preview) do |t|
  system("gem build mchat.gemspec && gem install ./mchat-#{Mchat::VERSION}.gem")
end


task default: %i[test]
