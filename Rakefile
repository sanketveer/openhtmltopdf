# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Rebuild the Java runner JAR and copy it into lib/"
task :java do
  Dir.chdir("java") { sh "mvn -q clean package" }
  cp "java/target/openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar",
     "lib/openhtmltopdf/java/"
end

task default: :spec
