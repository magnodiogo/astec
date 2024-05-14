# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
dir = Rails.root.join('app/assets/javascripts/controllers/', '*.{js}')
assets = %w(login.css login.js application_home.css home.js social_network.js jquery.Jcrop.css jquery.Jcrop.js impressao.css administrador.js) 
Dir[dir].each do |d|
  basename = File.basename(d)
  assets << "controllers/#{basename}"
end
#
#dir = Rails.root.join('app/assets/images/', 'logo-*.{png}')
#Dir[dir].each do |d|
#  basename = File.basename(d)
#  assets << "controllers/#{basename}"
#end

#dir = Rails.root.join('app/assets/javascripts/bower_components/i18n/', '*.{js}')
#Dir[dir].each do |d|
#  basename = File.basename(d)
#  assets << "bower_components/i18n/#{basename}"
#end

Rails.application.config.assets.precompile += assets
