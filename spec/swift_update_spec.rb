require File.expand_path('../spec_helper', __FILE__)

module Grenouille
  describe SwiftUpdate do
    it 'reports Swift 1.2 code correctly' do
      detected_version = SwiftUpdate.new.determine_version('spec/fixtures/Stargate.swift')

      detected_version.should == Gem::Version.new('1.2')
    end

    it 'reports Swift 1.1 code correctly' do
      detected_version = SwiftUpdate.new.determine_version('spec/fixtures/Blueprint.swift')

      detected_version.should == Gem::Version.new('1.1')
    end

    it 'can handle Swift 1.2 on iOS' do
      result = SwiftUpdate.new.update_to_latest_swift('spec/fixtures/Stargate.swift')

      result[:report].should == []
      result[:output].start_with?('spec/fixtures/Stargate.swift:10:8: error: no such module \'PeerKit\'').should == true
    end

    it 'can handle Swift 1.1 on iOS' do
      result = SwiftUpdate.new.update_to_latest_swift('spec/fixtures/Blueprint.swift')

      result[:report].count.should == 3
      result[:output].should == ''
    end

    it 'can handle Swift 1.2 on OS X' do
      result = SwiftUpdate.new.update_to_latest_swift('spec/fixtures/ChoreTask.swift')

      result[:report].should == []
      result[:output].should == ''
    end

    it 'can handle Swift 1.1 on OS X' do
      result = SwiftUpdate.new.update_to_latest_swift('spec/fixtures/Mac-1.1.swift')

      result[:report].count.should == 1
      result[:output].should == ''
    end

    it 'supports file globbing' do
      detected_version = SwiftUpdate.new.determine_version('spec/fixtures/*.swift')

      detected_version.should == Gem::Version.new('1.1')
    end

    it 'accepts a list of files' do
      detected_version = SwiftUpdate.new.determine_version(['spec/fixtures/ChoresTask.swift', 'spec/fixtures/Mac-1.1.swift'])

      detected_version.should == Gem::Version.new('1.1')
    end

    it 'throws when non Swift files are provided as arguments' do
      should.raise(StandardError) { SwiftUpdate.new.determine_version('spec/*.rb') }
    end
  end
end
