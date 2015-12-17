require 'xcinvoke'

module Grenouille
  class Xcode < XCInvoke::Xcode
    def self.new(developer_dir = nil)
      if developer_dir
        super
      else
        selected
      end
    end
  end
end
