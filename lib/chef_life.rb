require 'chef'
require 'thor'

## Patch ThorScmversion#current to return the version string
require_relative './thor_scmversion'

require_relative './chef_life/task/cookbook'
require_relative './chef_life/task/s3'
require_relative './chef_life/task/supermarket'
##
# ___+++________00++00______________
# ___+000________0++00______________
# ____++00_______++000_____+0_______
# ____++00______+++00_____+00_______
# _____++00_____++000+____+00_______
# _____++00____++000+0____++0_______
# _____++000___++888+00__++00_______
# ______++000_++888++000++00________
# ______++00000++00+00000+00________
# ______+++0000+000000000000________
# _______++00000000000000000________
# _______+++000000000000000_________
# ______+0+++00000000000000_________
# _____+0++++0000000000000__________
# ______+00+++000000000000__________
# _______++0++000000000000__________
# ________+++000000000000___________
# _________++000000000000___________
#
# I didn't choose the ChefLife. The ChefLife chose me.
##
module ChefLife
  class << self
    ## Load kinfe configuration
    def configure(file)
      Chef::Config.from_file(file)
    end
  end
end
