require 'aws-sdk'
require 'securerandom'
require 'thor'

module ChefLife
  ##
  # Do supermarket things
  ##
  class S3 < Thor
    include Thor::Actions
    namespace :s3

    class_option :aws_key, :type => :string, :aliases => :k
    class_option :aws_secret, :type => :string, :aliases => :s
    class_option :bucket, :type => :string, :aliases => :k

    desc 'push', 'Package and upload cookbook to an S3 bucket'
    option 'dry-run', :type => :boolean, :default => false
    def push
      ## Set defaults after Chef::Config is loaded
      options['aws_key'] ||= Chef::Config.knife['aws_secret_key_id']
      options['aws_secret'] ||= Chef::Config.knife['aws_secret_access_key']
      options['bucket'] ||= Chef::Config.knife['aws_artifact_bucket']

      ## Package the cookbook. We retrun `self` from Cookbook#package:
      cookbook = invoke(:cookbook, :package, nil, [])

      say_status :upload, "Cookbook #{ cookbook.name }@#{ cookbook.version } "\
        "to #{ options['bucket'] }"

      if options['dry-run']
        say_status 'dry-run', 'Cookbook is not uploaded in dry-run mode. Created '\
        "#{ cookbook.tarball }. Run the clean task to remove temporary files.", :yellow
      else
        ## TODO: Do S3 upload
      end
    ensure
      invoke :cookbook, :clean, [cookbook.temp_dir] unless options['dry-run']
    end

    desc 'yank [VERSION]', 'Remove a cookbook from an S3 bucket'
    def yank(version = nil)
    end
  end
end
