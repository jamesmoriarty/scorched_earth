module ScorchedEarth
  class EventRunner
    attr_reader :queue, :subscribers

    def initialize
      @queue       = Queue.new
      @subscribers = []
    end

    def publish(event)
      queue << event
    end

    def subscribe(klass, &block)
      subscribers << [klass, block]
    end

    def run(event)
      subscribers.each do |klass, block|
        block.call event if event.is_a? klass
      end
    end

    def process!
      processing = Array.new(queue.size) { queue.pop }

      processing.each do |event|
        run event
      end
    end
  end
end
