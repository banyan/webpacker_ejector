module WebpackerEjector
  module Generators
    class EjectGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_webpack_config
        loaders = Dir.glob("#{Rails.root.join('config/webpack/loaders')}/*")
          .map { |loader|
            basename = File.basename(loader, File.extname(loader))
            "require('./loaders/#{basename}')"
          }
        webpacker_config = YAML.load_file(Rails.root.join('config/webpacker.yml'))
        say 'Copying webpack.config.js'
        File.write(Rails.root.join('config/webpack/webpack.config.js'), ERB.new(File.read("#{__dir__}/templates/webpack.config.js.erb"), nil, '-').result(binding))
      end

      def install_dependencies
        say "Installing all dependencies"

        dependencies = %w[
          webpack
          webpack-cli
          mini-css-extract-plugin
          webpack-assets-manifest
          case-sensitive-paths-webpack-plugin
          pnp-webpack-plugin
          babel-loader
        ]

        run "yarn add #{dependencies.join(' ')}"
      end

      def inject_npm_run_scripts
        scripts = %Q(\n    "start": "webpack --progress --watch --config config/webpack/webpack.config.js",\n    "build": "NODE_ENV=production webpack --progress --config config/webpack/webpack.config.js")
        npm_scripts = %Q("scripts": {#{scripts}\n  },\n  )

        if File.foreach(Rails.root.join('package.json')).grep(/"scripts":\s+{/).any?
          insert_into_file Rails.root.join("package.json").to_s, "#{scripts},", after: /"scripts":\s+{/
        else
          insert_into_file Rails.root.join("package.json").to_s, npm_scripts, before: /"dependencies":\s+{/
        end
      end

      def replace_webpacker_yml
        remove_file "#{Rails.root.join('config/webpacker.yml')}"
        copy_file "#{__dir__}/templates/webpacker.yml", "#{Rails.root.join('config/webpacker.yml')}"
      end

      def remove_files
        remove_file "#{Rails.root.join('config/webpack/development.js')}"
        remove_file "#{Rails.root.join('config/webpack/test.js')}"
        remove_file "#{Rails.root.join('config/webpack/production.js')}"
        remove_file "#{Rails.root.join('config/webpack/environment.js')}"
        remove_file "#{Rails.root.join('bin/webpack')}"
        remove_file "#{Rails.root.join('bin/webpack-dev-server')}"

        say "Webpacker successfully ejected 🎉 🍰", :green
      end
    end
  end
end
