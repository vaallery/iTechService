# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.9'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w[ ckeditor/* jquery-ui-1.9.1.custom.min.css jstree/apple/style.css datepicker.css bootstrap-datetimepicker.min.css customicons.css ]

Rails.application.config.assets.precompile += %w[ association_filter.js.coffee currency-in-words.js accounting.js bootstrap-datepicker.js bootstrap-datetimepicker.min.js jquery.jstree.js ]
