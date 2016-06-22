require 'spec_helper'
require 'fileutils'

BASE_DIR = File.expand_path('~/.test_lookfile')
GIT_DIR = File.expand_path('~/.test_lookfile_git')
TEST_FILE = File.expand_path('~/.test_file')

describe Lookfile do
  before do
    Dir.mkdir(BASE_DIR)
    Dir.mkdir(GIT_DIR)
    `git -C '#{GIT_DIR}' init --bare`
    FileUtils.touch(TEST_FILE)
  end

  after do
    FileUtils.rm_rf(BASE_DIR)
    FileUtils.rm_rf(GIT_DIR)
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
      added_files, = Lookfile.add_files(TEST_FILE, BASE_DIR)

      expect(added_files).to include(TEST_FILE)
    end

    it 'can not add an non existent file' do
      non_existent_file_name = '~/.lookfile_non_existent_file'
      non_existent_file_name = File.expand_path(non_existent_file_name)
      _, error_files = Lookfile.add_files(non_existent_file_name, BASE_DIR)

      expect(error_files).to include(non_existent_file_name)
    end

    it 'show files on lookfile' do
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      message = Lookfile.show(BASE_DIR)

      expect(message).to include('Files on lookfile:')
      expect(message).to include(TEST_FILE)
    end
  end

  describe 'Version files on repository' do
    it 'add a new file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize(BASE_DIR)
      Lookfile.set_repository(repository_ssh_name, BASE_DIR)
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      message = Lookfile.push(BASE_DIR)
      git_head_message = `git -C '#{GIT_DIR}' show HEAD`
      n_commits = `git -C '#{GIT_DIR}' log | grep 'commit' -c`

      expect(n_commits).to eq("1\n")
      expect(message).to include('Added files')
      expect(message).to include(TEST_FILE[1..-1])
      expect(git_head_message).to include('Added files')
      expect(git_head_message).to include(TEST_FILE[1..-1])
    end

    it 'modify a file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize(BASE_DIR)
      Lookfile.set_repository(repository_ssh_name, BASE_DIR)
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      Lookfile.push(BASE_DIR)
      open(TEST_FILE, 'a') { |file| file.puts('modified') }
      message = Lookfile.push(BASE_DIR)
      git_head_message = `git -C '#{GIT_DIR}' show HEAD`
      n_commits = `git -C '#{GIT_DIR}' log | grep 'commit' -c`

      expect(n_commits).to eq("2\n")
      expect(message).to include('Modified files')
      expect(message).to include(TEST_FILE[1..-1])
      expect(git_head_message).to include('Modified files')
      expect(git_head_message).to include(TEST_FILE[1..-1])
    end

    it 'remove a file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize(BASE_DIR)
      Lookfile.set_repository(repository_ssh_name, BASE_DIR)
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      Lookfile.push(BASE_DIR)
      lookfile_dir = Lookfile.load_lookfile_dir(BASE_DIR)
      FileUtils.rm_rf(lookfile_dir + TEST_FILE)
      message = Lookfile.push(BASE_DIR)
      git_head_message = `git -C '#{GIT_DIR}' show HEAD`
      n_commits = `git -C '#{GIT_DIR}' log | grep 'commit' -c`

      expect(n_commits).to eq("2\n")
      expect(message).to include('Deleted files')
      expect(message).to include(TEST_FILE[1..-1])
      expect(git_head_message).to include('Deleted files')
      expect(git_head_message).to include(TEST_FILE[1..-1])
    end

    it 'do nothing if not have changes on file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize(BASE_DIR)
      Lookfile.set_repository(repository_ssh_name, BASE_DIR)
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      Lookfile.push(BASE_DIR)
      message = Lookfile.push(BASE_DIR)
      n_commits = `git -C '#{GIT_DIR}' log | grep 'commit' -c`

      expect(message).to include('Nothing to update')
      expect(n_commits).to eq("1\n")
    end

    it 'do restore a file' do
      repository_ssh_name = "file://#{GIT_DIR}"
      Lookfile.initialize(BASE_DIR)
      Lookfile.set_repository(repository_ssh_name, BASE_DIR)
      Lookfile.add_files(TEST_FILE, BASE_DIR)
      Lookfile.push(BASE_DIR)

      original_file = File.open(TEST_FILE, &:read)
      FileUtils.rm_rf(TEST_FILE)
      files_path = Lookfile.list_files(BASE_DIR)
      message = Lookfile.restore(files_path, BASE_DIR)
      restored_file = File.open(TEST_FILE, &:read)

      expect(message).to include(TEST_FILE)
      expect(original_file).to eq(restored_file)
    end
  end
end
