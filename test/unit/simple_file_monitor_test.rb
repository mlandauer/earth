# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require File.dirname(__FILE__) + '/file_monitor_test'

class SimpleFileMonitorTest < Test::Unit::TestCase
  include FileMonitorTest

  # Factory method
  def file_monitor(dir, queue)
    SimpleFileMonitor.new(dir, queue)
  end
end
