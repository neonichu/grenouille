require 'grenouille/xcode'
require 'pathname'
require 'tempfile'
require 'yaml'

# check for xcrun: error: unable to find utility "swift-update", not a developer tool or in PATH

module Grenouille
  class SwiftUpdate < Xcode
    def determine_version(file_glob)
      required_changes = update_to_latest_swift(file_glob)[:report]
      required_changes.count == 0 ? swift_version : previous_swift_version
    end

    def update_to_latest_swift(file_glob)
      fail 'Non-Swift files in input' if Pathname.glob(file_glob).reject { |f| f.extname == '.swift' }.count > 0
      files = Dir.glob(file_glob)
      fail 'No files in input' if files.empty?

      platform = guess_platform(file_glob)
      sdk_path = xcrun(%W(-sdk #{platform} -show-sdk-path)).chomp
      sdk_version = xcrun(%W(-sdk #{platform} -show-sdk-version)).chomp
      target = platform == :iphoneos ? %W(-target arm64-apple-ios#{sdk_version}) : []

      output = xcrun(%W(-sdk #{platform} swift-update))
      fail 'Unable to find "swift-update", install Xcode 6.3 or later' if output =~ /unable to find utility/

      Tempfile.open('swift-update.yaml') do |temp_file|
        temp_file.close
        args = %W(-sdk #{platform} swift-update -sdk #{sdk_path})
        args += files + target + %W(-o #{temp_file.path})
        output = xcrun(args, err: :merge)
        report = YAML.load(File.read(temp_file))
        { report: report, output: output }
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
      current = swift_version.segments
      Gem::Version.new("#{current[0]}.#{current[1] - 1}")
    end
  end
end
