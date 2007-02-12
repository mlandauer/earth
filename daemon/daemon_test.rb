#!/usr/bin/env ruby

require 'optparse'
require 'find'
require 'fileutils'
require 'pp'

class DaemonTest
  def initialize(root_directory, number_of_iterations)
    @root_directory = File.expand_path(root_directory)
    @number_of_iterations = number_of_iterations
    @iteration_count = 0
  end

  def make_random_name
    name_length = 3 + rand(4)
    chars = ("a".."z").to_a
    new_name = ""
    1.upto(name_length) { |i| new_name << chars[rand(chars.size)] }
    new_name
  end

  def find_random_directory(options={})
    use_options = { :include_root => true }
    use_options.update(options)
    all_directories = []
    Find.find(@root_directory) do |path|  
      all_directories << path if FileTest.directory? path and (path != @root_directory or use_options[:include_root])
    end
    all_directories[rand(all_directories.size)]
  end

  def find_random_file
    all_files = []
    Find.find(@root_directory) do |path|  
      all_files << path if not FileTest.directory? path
    end
    all_files[rand(all_files.size)]
  end

  def create_directory
    directory_to_create = File.join(self.find_random_directory, make_random_name)
    if not FileTest.exist? directory_to_create
      puts "Creating directory #{directory_to_create}"
      Dir.mkdir(directory_to_create)
      true
    end
  end

  def is_in_root_dir(directory)
    if directory == "/"
      return false
    elsif directory == @root_directory
      return true
    else
      return is_in_root_dir(File.dirname(directory))
    end
  end

  def is_sub_directory(directory1, directory2)
    while true
      if directory1 == directory2
        return true
      end
      if directory1 == "/"
        return false
      end
      directory1 = File.dirname(directory1)
    end
  end

  def delete_directory
    directory_to_delete = self.find_random_directory(:include_root => false)
    if directory_to_delete and directory_to_delete != @root_directory and is_in_root_dir(directory_to_delete)
      puts "Deleting directory #{directory_to_delete}"
      FileUtils.rm_rf(directory_to_delete)
      true
    end
  end

  def move_directory
    directory_to_move = self.find_random_directory(:include_root => false)
    directory_to_move_to = self.find_random_directory
    if directory_to_move and directory_to_move_to and \
      directory_to_move_to != directory_to_move and \
      (not is_sub_directory(directory_to_move, directory_to_move_to)) and \
      (not is_sub_directory(directory_to_move_to, directory_to_move)) then
      puts "Moving directory #{directory_to_move} to #{directory_to_move_to}"
      FileUtils.mv(directory_to_move, File.join(directory_to_move_to, File.basename(directory_to_move)))
      true
    end
  end

  def create_file
    file_to_create = File.join(self.find_random_directory, make_random_name)    
    if not FileTest.exist? file_to_create
      file_size = rand(20)
      puts "Creating file #{file_to_create} with size #{file_size}"
      File.open(file_to_create, File::CREAT|File::TRUNC|File::WRONLY) do |file|
        file.print("x" * file_size)
      end
      true
    end
  end

  def delete_file
    file_to_delete = self.find_random_file
    if file_to_delete
      puts "Deleting file #{file_to_delete}"
      File.delete(file_to_delete)
      true
    end
  end

  def move_file
    file_to_move = self.find_random_file
    directory_to_move_to = self.find_random_directory
    if file_to_move and directory_to_move_to and directory_to_move_to != File.dirname(file_to_move)
      file_to_move_to = File.join(directory_to_move_to, File.basename(file_to_move))
      puts "Moving file #{file_to_move} to #{file_to_move_to}"
      File.rename(file_to_move, file_to_move_to)
      true
    end
  end

  MIN_INITIAL_DIRECTORIES = 1
  MAX_INITIAL_DIRECTORIES = 10

  MIN_INITIAL_FILES = 5
  MAX_INITIAL_FILES = 50

  MIN_MUTATIONS_PER_ITERATION = 1
  MAX_MUTATIONS_PER_ITERATION = 10

  def main_loop

    # Clear out database
    puts "Clearing out database..."
    daemon_executable = File.join(File.dirname(__FILE__), "earth_daemon.rb")
    system("#{daemon_executable} -d -c")

    # Clear out working directory
    puts "Clearing out working directory..."
    Dir.foreach(@root_directory) do |entry|
      if entry != "." and entry != ".." then
        file = File.join(@root_directory, entry)
        FileUtils.rm_rf file
      end
    end

    # Create initial directory structure
    initial_directory_count = MIN_INITIAL_DIRECTORIES + rand(MAX_INITIAL_DIRECTORIES - MIN_INITIAL_DIRECTORIES)
    1.upto(initial_directory_count) { create_directory }

    # Populate initial directory structure with files
    initial_file_count = MIN_INITIAL_FILES + rand(MAX_INITIAL_FILES - MIN_INITIAL_FILES)
    1.upto(initial_file_count) { create_file }

    # Launch daemon in the background
    child_pid = fork do
      puts "Launching daemon in background, my pid is #{Process.pid}"
      exec("#{daemon_executable} -d \"#{@root_directory}\"")
    end

    at_exit { Process.kill("SIGINT", child_pid) }

    # Wait for daemon to index the initial directory structure

    puts "Waiting for daemon to index initial directory structure"
    while Earth::Server.this_server.last_update_finish_time.nil?
      sleep 2.seconds
    end

    puts "Daemon indexed initial directory structure"
    
    # Make sure daemon got the initial indexing right
    puts "Verifying data integrity"
    verify_data

    puts "Integrity verified"

    if @number_of_iterations.nil? then
      # loop indefinitely
      while true
        test_iteration
      end
    else
      # loop given number of times
      1.upto(@number_of_iterations) do
        test_iteration
      end
    end
  end

  def test_iteration
    mutation_count = MIN_MUTATIONS_PER_ITERATION + rand(MAX_MUTATIONS_PER_ITERATION - MIN_MUTATIONS_PER_ITERATION)
    puts ("-" * 72)
    puts "Iteration ##{@iteration_count}"
    @iteration_count += 1
    puts "Doing #{mutation_count} mutations"
    1.upto(mutation_count) { mutate_tree }
    puts "Waiting for daemon to update directory"

    1.upto(2) do
      last_time_updated = Earth::Server.this_server.last_update_finish_time
      begin
        sleep 2.seconds
      end until last_time_updated != Earth::Server.this_server.last_update_finish_time
    end
    puts "Verifying data integrity"
    verify_data
    puts "Integrity verified"
    sleep 2.seconds
  end

  def verify_data
    this_server = Earth::Server.this_server
    roots = Earth::Directory.roots_for_server(this_server) 

    # Assume only one directory root
    assert("Only have a single root for this server") { 1 == roots.size }
    root = roots[0]

    # Assume it's pointing to our test directory
    assert("Root directory name matches test root directory") { @root_directory == root.name }

    # Recursively validate the directory information
    compare_fs_directory_recursive(root, @root_directory)

    verify_cache_integrity_recursive(root)
  end

  def assert(message)
    raise "Assertion failed: #{message}" unless yield
  end

  def verify_cache_integrity_recursive(root)
    assert("Size and count for node ##{root.id} (#{root.path}) match") { root.size_and_count_with_caching == root.size_and_count_without_caching }
  end

  def compare_fs_directory_recursive(db_directory, fs_directory)
    fs_directory_names = []
    fs_file_names = []
    Dir.foreach(fs_directory) do |entry|
      if entry != "." and entry != ".."
        if FileTest.directory? File.join(fs_directory, entry)
          fs_directory_names << entry
        else
          fs_file_names << entry
        end
      end
    end
    fs_directory_names.sort!
    fs_file_names.sort!

    db_directory_names = db_directory.children.map { |child| child.name }
    db_file_names = db_directory.files.map { |file| file.name }

    db_directory_names.sort!
    db_file_names.sort!

    puts "directories from database:"
    pp(db_directory_names)
    puts "directories from file system:"
    pp(fs_directory_names)
    puts "files from database:"
    pp(db_file_names)
    puts "files from file system:"
    pp(fs_file_names)

    assert("Subdirectories in #{fs_directory} match database contents") { db_directory_names == fs_directory_names }
    assert("Files in #{fs_directory} match database contents") { db_file_names == fs_file_names }
    
    db_directory.files.each do |db_file|
      fs_file = File.join(fs_directory, db_file.name)
      fs_file_stat = File.lstat(fs_file)
      assert("Byte size of #{fs_file} matches database contents") { fs_file_stat.size == db_file.size }
      assert("Block size of #{fs_file} matches database contents") { fs_file_stat.blocks == db_file.blocks }
    end
    
    db_directory.children.each do |db_child|
      compare_fs_directory_recursive(db_child, File.join(fs_directory, db_child.name))
    end

  end

  def mutate_tree
    actions = [:create_directory, 
               :delete_directory, 
               :move_directory, 
               :create_file, 
               :delete_file, 
               :move_file 
    ]

    while true
      action_index = rand(actions.size)
      action = actions[action_index]
      if self.send(action)
        break
      else
        puts "(Couldn't do #{action}, trying a different operation)"
      end
    end
  end
end

development_mode = false
seed = nil
iterations = nil

opts = OptionParser.new
opts.banner = <<END_OF_STRING
Make changes in a directory and monitor the database to see that it is updated properly.
Usage: #{$0} [-d] <directory path>
END_OF_STRING

opts.on("-d", "--development", "Run the daemon test in development mode.") { development_mode = true }
opts.on("-s", "--seed NUMBER", "Use SEED to initialize the random number generator instead of the current time") do |_seed|
  seed = _seed.to_i
end
opts.on("-i", "--iterations NUMBER", "Only loop for the given number of iterations instead of indefinitely") do |_iterations|
  iterations = _iterations.to_i
end

opts.on_tail("-h", "--help", "Show this message") do
  puts opts
  exit
end

begin
  opts.parse!(ARGV)
rescue
  puts opts
  exit 1
end

if ARGV.length != 1
  puts opts
  exit 1
end

# Set environment to run in
if development_mode
  ENV["RAILS_ENV"] = "development"
else
  ENV["RAILS_ENV"] = "production"
end
require File.join(File.dirname(__FILE__), "..", "config", "environment")

parent_directory = ARGV[0]

if not FileTest.directory?(parent_directory)
  puts "ERROR: #{parent_directory} doesn't exist or is not a directory"
  exit 5
end

if seed.nil?
  seed = Time.new.to_i
end

puts "Using seed #{seed}"

srand(seed)

test = DaemonTest.new(parent_directory, iterations)
begin
  test.main_loop
ensure
  puts "Seed for this run was #{seed}"
end

