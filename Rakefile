require "bundler"
Bundler.setup

$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "rake"
require "rake/extensiontask"
require "rspec/core/rake_task"

def jruby?
  defined?(JRUBY_VERSION)
end

if jruby?
  require "rake/javaextensiontask"
  Rake::JavaExtensionTask.new do |ext|
    ext.name = "bson-ruby"
    ext.ext_dir = "src"
    ext.lib_dir = "lib"
  end
else
  require "rake/extensiontask"
  Rake::ExtensionTask.new do |ext|
    ext.name = "native"
    ext.ext_dir = "ext/bson"
    ext.lib_dir = "lib"
  end
end

require "bson/version"

def extension
  RUBY_PLATFORM =~ /darwin/ ? "bundle" : "so"
end

if RUBY_VERSION < "1.9"
  require "perf/bench"
else
  require_relative "perf/bench"
end

RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:rspec)

task :build => :clean_all do
  system "gem build bson.gemspec"
end

task :clean_all => :clean do
  begin
    Dir.chdir(Pathname(__FILE__).dirname + "lib/bson") do
      `rm native.#{extension}`
      `rm native.o`
      `rm native.jar`
    end
  rescue Exception => e
    puts e.message
  end
end

task :release => :build do
  system "git tag -a v#{BSON::VERSION} -m 'Tagging release: #{BSON::VERSION}'"
  system "git push --tags"
  system "gem push bson-#{BSON::VERSION}.gem"
  system "rm bson-#{BSON::VERSION}.gem"
end

namespace :benchmark do

  task :ruby => :clean_all do
    puts "Benchmarking pure Ruby..."
    require "bson"
    benchmark!
  end

  task :native => :compile do
    puts "Benchmarking with native extensions..."
    require "bson"
    benchmark!
  end
end

task :default => [ :clean_all, :spec, :compile, :rspec ]
