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
              'merb_helpers'

# 3. Libraries (ORM, testing tool, etc) you use.

use_orm :datamapper

use_test :rspec, 'dm-sweatshop'

use_template_engine :haml