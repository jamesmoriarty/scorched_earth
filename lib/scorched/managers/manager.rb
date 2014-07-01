require "delegate"
require_relative "../collection"

module Scorched
  class Manager < SimpleDelegator
    include Collection

    def update; end
    def render(win, height); end
  end
end
