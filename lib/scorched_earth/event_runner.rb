module ScorchedEarth
  class EventRunner
    attr_reader :events, :subscribers

    def initialize
      @events      = Queue.new
      @subscribers = []
    end

    def publish(event)
      events << event
    end

    def subscribe(klass, &block)
      subscribers << [klass, block]
    end

    def process_events!
      until events.empty?
        event = events.pop

        subscribers.each do |klass, block|
          block.call event if event.is_a? klass
        end
      end
    end
  end
end
