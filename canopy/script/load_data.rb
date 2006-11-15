#!/usr/bin/env ruby
#
# Loads the data from the reports into postgres
#

# EDIT THE FOLLOWING VARIABLES
servers = ["ikea", "freedom"]
psql_user = "rspintra"
psql_server = "localhost"
database = "rspintranet"
psql_cmd = "/usr/local/pgsql/bin/psql -U #{psql_user} -h #{psql_server} #{database} "

psql_backup_cmd = "#{psql_cmd}"
psql_backup_cmd<< " -c 'INSERT INTO archives (server, path, filesize, original_time) SELECT server, path, filesize, created_at FROM directories'"

psql_truncate_cmd = "#{psql_cmd}"
psql_truncate_cmd<< " -c 'TRUNCATE TABLE directories'"

# DON'T EDIT BEYOND THIS POINT

require 'tempfile'

def create_copy_data(temporaryfile, lines, server)
  lines.each { |l|
    # Lines are like:
    # SIZE  FULLPATHTODIR
    # were SIZE is an integer in KB (where empty == 0)
    # and  FULLPATHTODIR is a full path to the directory in question, i.e /film/pub/smr/
    # the separation is \s or \t
    # We use the limit = 2 for split as we can have directories with spaces on them
    size_and_path = l.split(/\s/, 2)
    size = size_and_path.first
    # We also remove the carriage return from the full path
    fullpath = size_and_path[1].sub!(/\n/, '')
  
    # HORRIBLE CODE ALERT!!!
    # Yup, I know ... it's pretty horrible to hard-code things ... oh well
    # Let's remove some unnecessary stuff from the paths
    # if SYDNEY:
    # => remove /export/film
    # if ADELAIDE:
    # => remove /raid/deepSTOR
    if server == "ikea"
      fullpath.sub!(/\/export\/film/, '')
    elsif server == "freedom"
      fullpath.sub!(/\/raid\/deepSTOR/, '')
    end
    temporaryfile.puts("#{server}\t#{fullpath}\t#{size.to_i}")
  }
end

tf = Tempfile.new("canopy")
servers.each { |s| 
  # The file we read is ALWAYS in the same location
  path_to_file = "/home/canopy/#{s}_canopy.report"
  fh = File.open(path_to_file, "r")
  lines = fh.readlines()
  fh.close
  # Process stuff and write it to the temp file
  create_copy_data(tf, lines, s)
}
path_tempfile = tf.path
tf.close

# We emtpy the "directories" table as we will fill it with new data
system(psql_truncate_cmd)

# We fill the "directories" table with brand new data
psql_copy_cmd = "#{psql_cmd}"
psql_copy_cmd<< " -c '\\copy directories (server, path, filesize) FROM \'#{path_tempfile}\''"
system(psql_copy_cmd)

# Let's move this to the historical "archives" table so that we can also make
# calculations on the data from today
system(psql_backup_cmd)
