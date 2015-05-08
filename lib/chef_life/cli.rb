require_relative '../chef_life'
require_relative '../chef_life/version'

module ChefLife
  ##
  # Construct a CLI
  ##
  class CLI < Thor
    class_option :config, :type => :string,
                          :aliases => :c,
                          :default => File.join(ENV['HOME'], '.chef/knife.rb')
    def initialize(*_)
      super
      ChefLife.configure(options['config'])
    end

    desc 'about', 'State your purpose!'
    def about
      say <<-THUGLIFE
         _
       .!.!.
        ! !     I THINK I SHALL $#%!, SHOWER
        ; :     AND THEN GO GET SOME SODA
       ;   :
      ;_____:   {{{{{ CHEF LIFE }}}}}
      ! Coca!
      !_____!
      :     :
      :     ;
      .'   '.
      :     :
      '''''

THUGLIFE
      say "      The Chef Life. Version #{ ChefLife::VERSION }"
    end

    desc 'cookbook SUBCOMMAND ... ARGS', 'Cookbook tasks'
    subcommand :cookbook, ChefLife::Cookbook

    desc 's3 SUBCOMMAND ... ARGS', 'S3 tasks'
    subcommand :s3, ChefLife::S3

    desc 'supermarket SUBCOMMAND ... ARGS', 'Supermarket tasks'
    subcommand :supermarket, ChefLife::Supermarket
  end
end
