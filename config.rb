require 'slim'
Slim::Engine.disable_option_validator!

activate :automatic_image_sizes
activate :directory_indexes
activate :i18n, mount_at_root: :ru

set :css_dir,    'assets/stylesheets'
set :js_dir,     'assets/javascripts'
set :images_dir, 'assets/images'

[:ru, :en].each do |lang|
  data.send(lang).documents.each do |document|
    proxy "/#{document.link}", '/document/index.html', locals: { document: document }, ignore: true do
      I18n.locale = lang
    end

    proxy "/#{lang.to_s}/#{document.link}", '/document/index.html', locals: { document: document }, ignore: true do
      I18n.locale = lang
    end
  end
end

configure :development do
  activate :livereload

  compass_config do |config|
    config.output_style = :expanded
  end
end

configure :build do
  activate :asset_hash
  activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :relative_assets

  set :relative_links, true

  compass_config do |config|
    config.output_style = :compressed
  end
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
end
