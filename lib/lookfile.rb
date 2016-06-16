require 'lookfile/version'
require 'fileutils'

# main module of lookfile gem
module Lookfile
  module_function

  BASE_DIR = '~/'.freeze
  LOOKFILE_DIR = '.lookfile'.freeze

  def initialize(base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    return nil if File.directory?(lookfile_dir)
    Dir.mkdir(lookfile_dir)
    lookfile_dir
  end

  def load_lookfile_dir(base_dir = BASE_DIR)
    base_dir = File.expand_path(base_dir)
    base_dir += '/' if base_dir[-1] != '/'
    base_dir + LOOKFILE_DIR
  end

  def add_files(files_path, base_dir = BASE_DIR)
    files_path = [files_path] unless files_path.is_a?(Array)
    files_path = files_path.map { |file_path| File.expand_path(file_path) }
    added_files = []
    error_files = []
    files_path.each do |file_path|
      list = add_one_file(file_path, base_dir) ? added_files : error_files
      list << file_path
    end
    [added_files, error_files]
  end

  def add_one_file(file_path, base_dir = BASE_DIR)
    lookfile_dir = load_lookfile_dir(base_dir)
    folder_path = lookfile_dir + file_path.scan(%r{(.+)\/}).flatten.first
    FileUtils.mkpath(folder_path)
    begin
      FileUtils.cp(file_path, folder_path)
      true
    rescue
      false
    end
  end
end
