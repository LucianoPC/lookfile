$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'lookfile'
require 'commands/init'
require 'commands/add'
require 'commands/push'
require 'commands/status'
require 'commands/show'
require 'commands/restore'
require 'commands/set_repository'

require 'fileutils'

BASE_DIR = File.expand_path('~/.test_lookfile')
GIT_DIR = File.expand_path('~/.test_lookfile_git')
TEST_FILE = File.expand_path('~/.test_file')
