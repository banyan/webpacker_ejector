require "test_helper"
require "generators/webpacker_ejector/eject_generator"

class WebpackerEjector::EjectGeneratorTest < ::Rails::Generators::TestCase
  include Minitest::Hooks

  tests WebpackerEjector::Generators::EjectGenerator
  destination File.expand_path("../sample", __dir__)

  def before_all
    Dir.chdir(File.expand_path("../sample", __dir__)) do
      run_generator
    end
  end

  Minitest.after_run do
    system "git checkout test/sample && git clean -fd test/sample"
  end

  test 'generates webpack.config.js' do
    assert_file "config/webpack/webpack.config.js"
  end

  test 'install dependencies' do
    assert_file "package.json" do |content|
      assert_match(/webpack/, content)
      assert_match(/webpack-cli/, content)
      assert_match(/mini-css-extract-plugin/, content)
      assert_match(/webpack-assets-manifest/, content)
      assert_match(/case-sensitive-paths-webpack-plugin/, content)
      assert_match(/pnp-webpack-plugin/, content)
      assert_match(/babel-loader/, content)
    end
  end

  test 'hoge' do
    assert_file "package.json" do |content|
      json = JSON.parse(content)
      assert_equal json["scripts"]["start"], "webpack --progress --watch --config config/webpack/webpack.config.js"
      assert_equal json["scripts"]["build"], "NODE_ENV=production webpack --progress --config config/webpack/webpack.config.js"
    end
  end

  test 'replace webpacker.yml' do
    assert_file "config/webpacker.yml" do |content|
      assert_equal content, File.read(File.expand_path("../../lib/generators/webpacker_ejector/templates/webpacker.yml", __dir__))
    end
  end

  test 'remove files' do
    assert_no_file "config/webpack/development.js"
    assert_no_file "config/webpack/test.js"
    assert_no_file "config/webpack/production.js"
    assert_no_file "config/webpack/environment.js"
    assert_no_file "bin/webpack"
    assert_no_file "bin/webpack-dev-server"
  end
end
