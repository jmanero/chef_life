name             "dyn_apt_repository"
maintainer       "John Manero"
maintainer_email "jmanero@dyn.com"
license          "All rights reserved"
description      "Installs/Configures an APT repository"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          IO.read(File.join(File.dirname(__FILE__), "VERSION")) rescue "0.0.1"

# dependencies
depends "apt"
depends "partial_search"
depends "repository"
