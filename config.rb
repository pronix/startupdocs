require 'slim'
Slim::Engine.disable_option_validator!

activate :automatic_image_sizes
activate :directory_indexes
activate :i18n, mount_at_root: :ru

set :css_dir,    'assets/stylesheets'
set :js_dir,     'assets/javascripts'
set :images_dir, 'assets/images'
set :relative_links, true

[:ru, :en].each do |lang|
  data.send(lang).documents.each do |document|
    proxy "/#{document.link}/index.html", '/document/index.html', locals: { document: document }, ignore: true do
      I18n.locale = lang
    end

    proxy "/#{lang.to_s}/#{document.link}/index.html", '/document/index.html', locals: { document: document }, ignore: true do
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

  compass_config do |config|
    config.output_style = :compressed
  end
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  deploy.commit_message = 'Site updated to ' << `git log --pretty="%h" -n1`
end

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-61714922-1'
end
