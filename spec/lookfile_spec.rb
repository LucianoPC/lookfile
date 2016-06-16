require 'spec_helper'
require 'fileutils'

BASE_DIR = File.expand_path('~/.test_lookfile')

describe Lookfile do
  before do
    Dir.mkdir(BASE_DIR)
  end

  after do
    FileUtils.rm_rf(BASE_DIR)
  end

  it 'has a version number' do
    expect(Lookfile::VERSION).not_to be nil
  end

  describe 'Initialize Lookfile directory' do
    it 'get lookfile with default base dir' do
      lookfile_dir = Lookfile.lookfile_dir
      default_base_dir = File.expand_path(Lookfile::BASE_DIR)

      expect(lookfile_dir).to include(default_base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end

    it 'get lookfile with setted base dir' do
      base_dir = File.expand_path(BASE_DIR)
      lookfile_dir = Lookfile.lookfile_dir(base_dir)

      expect(lookfile_dir).to include(base_dir)
      expect(lookfile_dir).to include(Lookfile::LOOKFILE_DIR)
    end

    it 'initialize lookfile' do
      lookfile_dir = Lookfile.initialize(BASE_DIR)

      expect(lookfile_dir).to eq "#{BASE_DIR}/#{Lookfile::LOOKFILE_DIR}"
    end
  end
end
