require 'lookfile/version'

# main module of lookfile gem
module Lookfile
  module_function

  BASE_DIR = '~/'
  LOOKFILE_DIR = '.lookfile/'.freeze

  def initialize
    dir = lookfile_dir
    return nil if File.directory?(dir)
    Dir.mkdir(dir)
    dir
  end

  def lookfile_dir(base_dir = BASE_DIR)
    base_dir = File.expand_path(base_dir)
    base_dir += '/' if base_dir[-1] != '/'
    base_dir + LOOKFILE_DIR
  end
end
