require 'chef'
require 'chef/cookbook_site_streaming_uploader'
require 'securerandom'
require 'thor'

module ChefLife
  ##
  # Do supermarket things
  ##
  class Supermarket < Thor
    include Thor::Actions
    namespace :supermarket

    class_option :site, :type => :string,
                        :aliases => :s,
                        :default => Chef::Config.knife['supermarket_site'] || 'https://supermarket.chef.io/'
    class_option :user, :type => :string,
                        :aliases => :u,
                        :default => Chef::Config.knife['supermarket_user'] || Chef::Config.node_name
    class_option :key, :type => :string,
                        :aliases => :k,
                        :default => Chef::Config.knife['supermarket_key'] || Chef::Config.client_key

    desc 'push', 'Package and upload cookbook to a supermarket'
    option 'dry-run', :type => :boolean, :default => false
    def push
      ## Package the cookbook. We retrun `self` from Cookbook#package:
      cookbook = invoke(:cookbook, :package, nil, [])

      say_status :upload, "Cookbook #{ cookbook.name }@#{ cookbook.version } "\
        "to #{ options['site'] } as #{ options['user'] }"

      if options['dry-run']
        say_status 'dry-run', 'Cookbook is not uploaded in dry-run mode. Created '\
        "#{ cookbook.tarball }. Run the clean task to remove temporary files.", :yellow
      else
        http_resp = Chef::CookbookSiteStreamingUploader.post(
          File.join(options['site'], '/api/v1/cookbooks'),
          options['user'], options['key'],
          :tarball => File.open(cookbook.tarball),
          :cookbook => { :category => '' }.to_json
        )

        if http_resp.code.to_i != 201
          say_status :error, "Error uploading cookbook: #{ http_resp.code } #{ http_resp.message }", :red
          say http_resp.body
        end
      end
    ensure
      invoke :cookbook, :cleanup, nil, [cookbook.temp_dir] unless options['dry-run']
    end

    desc 'yank [VERSION]', 'Remove a cookbook from a supermarket'
    def yank(version = nil)
    end
  end
end
