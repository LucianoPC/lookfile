$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lookfile'
require 'coveralls'
Coveralls.wear!

BASE_DIR = File.expand_path('~/.test_lookfile')
GIT_DIR = File.expand_path('~/.test_lookfile_git')
TEST_FILE = File.expand_path('~/.test_file')
