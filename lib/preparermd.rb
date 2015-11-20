require "jekyll"
require "jekyll-assets"
require "bundler"
require "bundler/cli"
require "bundler/cli/install"

require "preparermd/version"
require "preparermd/config"
require "preparermd/overrides/jekyll"
require "preparermd/overrides/environment"
require "preparermd/plugins/metadata_envelopes"

module PreparerMD

  # Primary entry point for the site build. Execute a Jekyll build with customized options.
  #
  def self.build(source = Dir.pwd, destination = File.join(Dir.pwd, '_site'))
    @config = Config.new

    config_path = File.join(source, "_deconst.json")
    if File.exist?(config_path)
      File.open(config_path, "r") { |cf| @config.load_from(cf.read) }
    end

    @config.validate

    if File.exist?("Gemfile")
      puts "Installing dependencies from the Jekyll environment."
      Bundler::CLI::Install.new({}).run
    end

    puts "Building and submitting content."
    Jekyll::Commands::Build.process({source: source, destination: destination})
  end

  # Access the preparer's configuration.
  #
  def self.config
    @config
  end

end
