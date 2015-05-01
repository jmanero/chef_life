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

    desc 'share', 'Package and upload cookbook to a supermarket'
    option :aws_key, :type => :string,
                     :aliases => :k,
                     :default => Chef::Config.knife['aws_secret_key_id']
    option :aws_secret, :type => :string,
                        :aliases => :s,
                        :default => Chef::Config.knife['aws_secret_access_key']
    option :bucket, :type => :string,
                    :aliases => :k,
                    :default => Chef::Config.knife['aws_cookbook_bucket']
    option 'dry-run', :type => :boolean, :default => false
    def share
      ## Package the cookbook. We retrun `self` from Cookbook#package:
      cookbook = invoke(:cookbook, :package, nil, [])

      say_status :upload, "Cookbook #{ cookbook.name }@#{ cookbook.version } "\
        "to #{ options['bucket'] }"

      if options['dry-run']
        say_status 'dry-run', 'Cookbook is not uploaded in dry-run mode. Created '\
        "#{ cookbook.tarball }. Run the clean task to remove temporary files.", :yellow
      else
        # http_resp = Chef::CookbookSiteStreamingUploader.post(
        #   File.join(options['site'], '/api/v1/cookbooks'),
        #   options['user'], options['key'],
        #   :tarball => File.open(cookbook.tarball),
        #   :cookbook => { :category => '' }.to_json
        # )
        #
        # if http_resp.code.to_i != 201
        #   say_status :error, "Error uploading cookbook: #{ http_resp.code } #{ http_resp.message }", :red
        #   say http_resp.body
        # end
      end
    ensure
      invoke :cookbook, :cleanup, nil, [cookbook.temp_dir] unless options['dry-run']
    end
  end
end
