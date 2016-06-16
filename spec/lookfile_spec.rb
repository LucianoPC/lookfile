require 'spec_helper'
require 'fileutils'

BASE_DIR = File.expand_path('~/.test_lookfile')
TEST_FILE = File.expand_path('~/.test_file')

describe Lookfile do
  before do
    Dir.mkdir(BASE_DIR)
    FileUtils.touch(TEST_FILE)
  end

  after do
    FileUtils.rm_rf(BASE_DIR)
    FileUtils.rm_rf(TEST_FILE)
  end

  it 'has a version number' do
    expect(Lookfile::VERSION).not_to be nil
  end

  describe 'Initialize Lookfile directory' do
    it 'get lookfile with default base dir' do
      lookfile_dir = Lookfile.load_lookfile_dir
      default_base_dir = File.expand_path(Lookfile::BASE_DIR)

      expect(lookfile_dir).to include(default_base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end

    it 'get lookfile with setted base dir' do
      base_dir = File.expand_path(BASE_DIR)
      lookfile_dir = Lookfile.load_lookfile_dir(base_dir)

      expect(lookfile_dir).to include(base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end

    it 'initialize lookfile' do
      lookfile_dir = Lookfile.initialize(BASE_DIR)
      git_status = `GIT_DIR=#{lookfile_dir}/.git git status`

      expect(lookfile_dir).to eq "#{BASE_DIR}/#{Lookfile::LOOKFILE_DIR}"
      expect(git_status).to include('On branch master')
    end
  end

  describe 'Add files to lookfile folder' do
    it 'can add an existing file' do
      added_files, = Lookfile.add_files(TEST_FILE)

      expect(added_files).to include(TEST_FILE)
    end

    it 'can not add an non existent file' do
      non_existent_file_name = '~/.lookfile_non_existent_file'
      non_existent_file_name = File.expand_path(non_existent_file_name)
      _, error_files = Lookfile.add_files(non_existent_file_name)

      expect(error_files).to include(non_existent_file_name)
    end
  end
end
