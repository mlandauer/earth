require 'open3'

desc "Checks in changes after successfully running tests and automatically adding to the changelog. Set MSG with your check-in message. This is also the message added to the ChangeLog"
task :ci => 'ci:read_config' do
  begin
    message = ENV['MSG'] or raise "please set checkin message MSG"
    Rake::Task['ci:run_tests'].invoke
    Rake::Task['ci:update_changelog'].invoke
    Rake::Task['ci:svn'].invoke
    
    rm 'ChangeLog.bak'
  rescue
    puts "UNABLE TO COMMIT (#{$!})"
    system("svn st")
  ensure
    revert_changelog
  end
end


namespace :ci do
  desc 'Test all units and functionals, parsing the output for failures'
  task :run_tests do
    failures,errors = run_tests
    raise "#{failures} failures, #{errors} errors" if failures > 0 or errors > 0
  end
  
  desc 'update the changelog with the checkin message'
  task :update_changelog => :read_config do
    cp 'ChangeLog', 'ChangeLog.bak'
    today = Time.now.strftime("%Y-%m-%d")
    
    header = [today, CONFIG['name'], "<#{CONFIG['email']}>"] * "\t"
    files = get_svn_files
    
    text = %{#{header}

  * #{files * ', '}: #{ENV['MSG']}

}
    old_change = File.read('ChangeLog')
    
    open('ChangeLog','w') do |f|
      f << text
      f << old_change
    end
    
    cp 'ChangeLog', 'ChangeLog.latest'
  end
  
  desc 'perform the svn checkin'
  task :svn do
    cmd = "svn ci -m '#{ENV['MSG']}'"
    system(cmd)
    raise "#{cmd} failed" unless $?.success?
  end


  task :read_config do
    CONFIG = YAML.load_file("#{ENV['HOME']}/.checkinrc")
  end
end


def tee(cmd,&block)
  oldsync = $stdout.sync
  $stdout.sync = true
  
  sep = ?\n
  
  IO.popen("rake test") do |io|
    io.sync = true
    buffer = ""
    
    while (c = io.getc) != nil
      print c.chr
      
      if c == sep
        yield buffer
        buffer = ""
      else
        buffer << c.chr
      end
    end
  end
  
ensure
  $stdout.sync = oldsync
end

def get_svn_files
  returning([]) do |files|
    IO.popen('svn st -q') do |io|
      io.each do |line|
        _,file = *line.match(/\s*\w+\s+(.*)$/)
        files << file
      end
    end
  end
end


def run_tests
  total_failures = 0
  total_errors = 0
    
  tee('rake test') do |line|
    if match = line.match(/(\d+)\s+failures.*(\d+)\s+errors/)
      _,failures,errors = *match
      total_failures += failures.to_i unless failures == "0"
      total_errors   += errors.to_i   unless errors   == "0"
    end  
  end

  [total_failures,total_errors]
end

def revert_changelog
  mv 'ChangeLog.bak', 'ChangeLog' if File.exist? 'ChangeLog.bak'
end