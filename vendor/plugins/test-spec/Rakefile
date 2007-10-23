# Rakefile for testspec.  -*-ruby-*-
require 'rake/rdoctask'
require 'rake/testtask'


desc "Run all the tests"
task :default => [:test]

desc "Do predistribution stuff"
task :predist => [:chmod, :changelog, :rdoc, :distmanifest]


desc "Make an archive as .tar.gz"
task :dist => :test do
  system "export DARCS_REPO=#{File.expand_path "."}; " +
         "darcs dist -d test-spec-#{get_darcs_tree_version}"
end

# Helper to retrieve the "revision number" of the darcs tree.
def get_darcs_tree_version
  unless File.directory? "_darcs"
    load 'lib/test/spec/version.rb'
    return Test::Spec::VERSION
  end

  changes = `darcs changes`
  count = 0
  tag = "0.0"
  
  changes.each("\n\n") { |change|
    head, title, desc = change.split("\n", 3)
    
    if title =~ /^  \*/
      # Normal change.
      count += 1
    elsif title =~ /tagged (.*)/
      # Tag.  We look for these.
      tag = $1
      break
    else
      warn "Unparsable change: #{change}"
    end
  }

  tag + "." + count.to_s
end


desc "Make binaries executable"
task :chmod do
  Dir["bin/*"].each { |binary| File.chmod(0775, binary) }
end

desc "Generate a ChangeLog"
task :changelog do
  system "darcs changes --repo=#{ENV["DARCS_REPO"] || "."} >ChangeLog"
end


desc "Generate RDox"
task "SPECS" do
  ruby "bin/specrb -Ilib:test -a --rdox >SPECS"
end


begin
  # To generate the gem, run "rake package"

  $" << "sources"  if defined? FromSrc
  require 'rubygems'

  require 'rake'
  require 'rake/clean'
  require 'rake/packagetask'
  require 'rake/gempackagetask'
  require 'rake/contrib/rubyforgepublisher'
  require 'fileutils'
  require 'hoe'
rescue LoadError
  # Too bad.

  desc "Run all the tests"
  task :test => :chmod do
    ruby "bin/specrb -Ilib:test -w #{ENV['TEST'] || '-a'} #{ENV['TESTOPTS']}"
  end

else
  
  RDOC_OPTS = ['--title', "test/spec documentation",
               "--opname", "index.html",
               "--line-numbers", 
               "--main", "README",
               "--inline-source"]
  
  # Generate all the Rake tasks
  # Run 'rake -T' to see list of generated tasks (from gem root directory)
  hoe = Hoe.new("test-spec", get_darcs_tree_version) do |p|
    p.author = "Christian Neukirchen"
    p.description = "a Behaviour Driven Development interface for Test::Unit"
    p.email = "chneukirchen@gmail.com"
    p.summary = <<EOF
test/spec layers an RSpec-inspired interface on top of Test::Unit, so
you can mix TDD and BDD (Behavior-Driven Development).

test/spec is a clean-room implementation that maps most kinds of
Test::Unit assertions to a `should'-like syntax.
EOF
    p.url = "http://test-spec.rubyforge.org"
    p.test_globs = ["test/**/{test,spec}_*.rb"]
    p.clean_globs = []
    # These are actually optional, but we can't tell Gems that.
    # p.extra_deps = ['flexmock','>= 0.4.1'],['mocha','>= 0.3.2']
    p.need_tar = false          # we do that ourselves
    p.changes = File.read("README")[/^== History\n(.*?)^==/m, 1].
                                    split(/\n{2,}/).last
  end rescue nil

  task :package => ["Manifest.txt", :dist]

  # Yes, this is ridiculous.
  hoe.spec.dependencies.delete_if { |dep| dep.name == "hoe" } if hoe
  Rake.application.instance_variable_get(:@tasks).delete :docs
  Rake.application.instance_variable_get(:@tasks).delete "doc/index.html"
  task :docs => :rdoc
end


desc "Generate RDoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include 'README'
  rdoc.rdoc_files.include 'ROADMAP'
  rdoc.rdoc_files.include 'SPECS'
  rdoc.rdoc_files.include('lib/**/*.rb')
end
task :rdoc => "SPECS"


desc "Generate Manifest.txt"
task "Manifest.txt" do
  system "darcs query manifest | sed 's:^./::' >Manifest.txt"
end

desc "Generate Manifest.txt for dist"
task :distmanifest do
  File.open("Manifest.txt", "wb") { |manifest|
    Dir["**/*"].each { |file|
      manifest.puts file  if File.file? file
    }
  }
end

begin
  require 'rcov/rcovtask'
  
  Rcov::RcovTask.new do |t|
    t.test_files = FileList['test/{spec,test}_*.rb'] + ['--', '-rs']   # evil
    t.verbose = true     # uncomment to see the executed command
    t.rcov_opts = ["--text-report",
                   "--include-file", "^lib,^test",
                   "--exclude-only", "^/usr,^/home/.*/src"]
  end
rescue LoadError
end
