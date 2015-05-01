require 'chef/cookbook/metadata'
require 'fileutils'
require 'ignorefile'
require 'securerandom'
require 'thor'
require 'thor-scmversion'

module ChefLife
  ##
  # Do cookbook things
  ##
  class Cookbook < Thor
    include Thor::Actions
    namespace :cookbook

    attr_reader :name
    attr_reader :version
    attr_reader :tarball
    attr_reader :temp_id
    attr_reader :temp_dir

    ## Don't vendor VCS files.
    ## Reference GNU tar --exclude-vcs: https://www.gnu.org/software/tar/manual/html_section/tar_49.html
    ## Boosted from https://github.com/berkshelf/berkshelf/blob/master/lib/berkshelf/berksfile.rb
    EXCLUDED_VCS_FILES = [
      '.arch-ids', '{arch}', '.bzr', '.bzrignore', '.bzrtags',
      'CVS', '.cvsignore', '_darcs', '.git', '.hg', '.hgignore',
      '.hgrags', 'RCS', 'SCCS', '.svn', '**/.git', '.temp'].freeze

    desc 'package', 'Generate a tar gzip bundle of a cookbook'
    def package
      @temp_id = SecureRandom.hex(16)
      @temp_dir = File.join('.temp/', @temp_id)

      ignore_file = IgnoreFile.new('chefignore', '.gitignore', EXCLUDED_VCS_FILES)
      cookbook = Chef::Cookbook::Metadata.new

      invoke :version, :current, []
      cookbook.from_file('metadata.rb')

      @name = cookbook.name
      @version = cookbook.version

      tarball_name = "#{ cookbook.name }-#{ cookbook.version }.tgz"
      @tarball = File.join(@temp_dir, tarball_name)

      ## Place to assemble files to be tar'd
      cookbook_stage = File.join(@temp_dir, cookbook.name)
      empty_directory cookbook_stage

      cookbook_files = Dir.glob('**/{*,.*}')
      ignore_file.apply!(cookbook_files)

      say_status :package, "Cookbook #{ cookbook.name }@#{ cookbook.version }"

      ## First, make directories
      cookbook_files.select { |f| File.directory?(f) }.each do |f|
        FileUtils.mkdir_p(File.join(cookbook_stage, f))
      end

      ## Then hard-link files
      cookbook_files.reject { |f| File.directory?(f) }.each do |f|
        FileUtils.ln(f, File.join(cookbook_stage, f))
      end

      ## Finally, write metadata.json
      IO.write(File.join(cookbook_stage, 'metadata.json'), cookbook.to_json)

      ## And package it all up.
      inside(@temp_dir) do
        run "tar -czf #{ tarball_name } #{ cookbook.name }"
      end

      self
    end

    desc 'cleanup', 'Cleanup temporary files from packaging'
    def cleanup(temp = nil)
      return remove_dir temp unless temp.nil?
      Dir.glob('.temp/*').each { |t| remove_dir t }
    end
  end
end
