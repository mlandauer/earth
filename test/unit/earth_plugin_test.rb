# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'earth_plugin_interface', 'earth_plugin.rb')

class PluginThatValidates < EarthPlugin
  def self.plugin_name
    "PluginThatValidates"
  end
  
  def self.plugin_version
    15
  end
end

class PluginWithMissingPluginName < EarthPlugin
  def self.plugin_version
    15
  end
end

class PluginWithMissingPluginVersion < EarthPlugin
  def self.plugin_name
    "PluginThatValidates"
  end
end

class PluginWithBadPluginVersion < EarthPlugin
  def self.plugin_name
    "PluginThatValidates"
  end
  
  # This method shouldn't return a string
  def self.plugin_version
    "a string"
  end
end

class PluginWithBadPluginName < EarthPlugin
  def self.plugin_name
    raise RuntimeError
  end
  
  def self.plugin_version
    15
  end
end

class PluginWithBrokenPluginNameMethod < EarthPlugin
end

class EarthPluginTest < Test::Unit::TestCase
  def test_validate_with_valid_plugin
    EarthPlugin.validate_plugin_class(PluginThatValidates)
  end

  def test_validate_with_missing_plugin_name
    assert_raise InvalidEarthPluginError do
      EarthPlugin.validate_plugin_class(PluginWithMissingPluginName)
    end
  end

  def test_validate_with_missing_plugin_version
    assert_raise InvalidEarthPluginError do
      EarthPlugin.validate_plugin_class(PluginWithMissingPluginVersion)
    end
  end
  
  def test_validate_with_bad_plugin_version
    assert_raise InvalidEarthPluginError do
      EarthPlugin.validate_plugin_class(PluginWithBadPluginVersion)
    end
  end
  
  def test_validate_with_bad_plugin_name
    assert_raise InvalidEarthPluginError do
      EarthPlugin.validate_plugin_class(PluginWithBadPluginName)
    end
  end
end
