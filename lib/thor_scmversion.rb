require 'thor-scmversion'

##
# Make the `current` task behave the way I think it should.
##
class ThorSCMVersion::Tasks
  method_option :version_file_path,
                :type => :string,
                :default => nil,
                :desc => 'An additional path to copy a VERSION file to on the file system.'

  desc 'current', 'Show current SCM tagged version'
  def current
    write_version(options[:version_file_path])
    say_status :version, "Current #{ current_version }"

    current_version.to_s
  end
end
