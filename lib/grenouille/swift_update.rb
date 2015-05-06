require 'grenouille/xcode'
require 'tempfile'
require 'yaml'

# check for xcrun: error: unable to find utility "swift-update", not a developer tool or in PATH

module Grenouille
  class SwiftUpdate < Xcode
    def determine_version(file_glob)
      required_changes = update_to_latest_swift(file_glob)[:report]
      required_changes.count == 0 ? current_swift_version : previous_swift_version
    end

    def update_to_latest_swift(file_glob)
      fail 'Non-Swift files in input' if Dir.glob(file_glob).reject { |f| Pathname.new(f).extname == '.swift' }.count > 0
      files = Dir.glob(file_glob).join(' ')
      fail 'No files in input' if files == ''

      platform = guess_platform(file_glob)
      sdk_path = xcrun("-sdk #{platform} -show-sdk-path").chomp
      sdk_version = xcrun("-sdk #{platform} -show-sdk-version").chomp
      target = platform == :iphoneos ? "-target arm64-apple-ios#{sdk_version}" : ''

      output = xcrun("-sdk #{platform} swift-update 2>&1")
      fail 'Unable to find "swift-update", install Xcode 6.3 or later' if output =~ /unable to find utility/

      temp_file = Tempfile.new('swift-update')
      begin
        output = xcrun("-sdk #{platform} swift-update -sdk #{sdk_path} #{files} #{target} -o #{temp_file.path} 2>&1")
        report = YAML.load(File.read(temp_file))
        { report: report, output: output }
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    private

    def guess_platform(file_glob)
      Dir.glob(file_glob).each do |file|
        content = File.read(file)
        return :macosx if content =~ /^import AppKit$/
        return :macosx if content =~ /NSTask/
      end

      :iphoneos
    end

    def previous_swift_version
      current = current_swift_version.segments
      Gem::Version.new("#{current[0]}.#{current[1] - 1}")
    end
  end
end
