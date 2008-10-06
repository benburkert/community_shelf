$KCODE = 'UTF8'

#
# ==== Structure of Merb initializer
#
# 1. Load paths.

Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

Merb.push_path(:lib, Merb.root / :lib)

# 2. Dependencies configuration.

# General
require 'isbn/tools'    # gem name is 'isbn-tools'
require 'openid'        # gem name is 'ruby-openid'
require 'openid/store/filesystem'
require 'curb'
require 'xml/libxml'

# DataMapper
dependencies  'dm-aggregates',
              'dm-is-permalink',
              'dm-paginate',
              'dm-serializer',
              'dm-timestamps',
              'dm-types',
              'dm-validations'

# Merb
dependencies  'merb-action-args',
              'merb-assets',
              #'merb-cache',
              'merb_helpers',
              'merb_auth-core',
              'merb_auth-more'

# 3. Libraries (ORM, testing tool, etc) you use.

use_orm :datamapper

use_test :rspec, 'dm-sweatshop'

use_template_engine :haml

# 4. Application-specific configuration.

Merb::BootLoader.after_app_loads do

  require 'merb_auth-more/strategies/abstract_password'   # this looks like an merb_auth bug
  require 'merb_auth-more/strategies/basic/openid'

  class Authentication
    def store_user(user)
      return nil unless user
      user.id
    end

    def fetch_user(session_info)
      User.get(session_info)
    end
  end
end