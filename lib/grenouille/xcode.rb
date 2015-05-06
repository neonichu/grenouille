require 'rubygems/version'

module Grenouille
  class Xcode
    def initialize(developer_dir = `xcode-select -p`.chomp)
      @developer_dir = developer_dir
    end

    def current_version
      get_version('xcodebuild -version')
    end

    def current_swift_version
      get_version('swift -version', 3) || get_version('swift -version', 2)
    end

    def xcrun(command)
      `DEVELOPER_DIR=#{@developer_dir} xcrun #{command}`
    end

    private

    def get_version(command, index = 1)
      version_string = xcrun(command).split(' ')

      if version_string.count >= index + 1 && Gem::Version.correct?(version_string[index])
        return Gem::Version.new(version_string[index])
      end

      nil
    end
  end
end
