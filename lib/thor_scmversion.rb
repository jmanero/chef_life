require 'thor-scmversion'

class ThorSCMVersion::Tasks
  method_option :version_file_path,
    :type => :string,
    :default => nil,
    :desc => "An additional path to copy a VERSION file to on the file system."
  desc "current", "Show current SCM tagged version"
  def current
    write_version(options[:version_file_path])
    say_status :version, "Current #{ current_version.to_s }"

    current_version.to_s
  end
end
