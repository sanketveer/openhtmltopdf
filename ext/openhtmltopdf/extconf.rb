# frozen_string_literal: true

require "fileutils"

gem_root = File.expand_path("../..", __dir__)
java_dir = File.join(gem_root, "java")
jar_name = "openhtmltopdf-runner-0.1.0-jar-with-dependencies.jar"
out_dir  = File.join(gem_root, "lib", "openhtmltopdf", "java")

mvn = ENV.fetch("MVN", "mvn")
ok = system(mvn, "-B", "-q", "clean", "package", chdir: java_dir)
abort "openhtmltopdf: Maven build failed. Install Java 11+ and Maven." unless ok

FileUtils.mkdir_p(out_dir)
FileUtils.cp(File.join(java_dir, "target", jar_name), out_dir)

# Nothing to compile or install beyond the JAR copied above.
File.write("Makefile", "all:\n\t@true\ninstall:\n\t@true\nclean:\n\t@true\n")
