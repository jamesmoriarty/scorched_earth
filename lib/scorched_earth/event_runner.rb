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

    def process!
      processing = queue.size.times.map { queue.pop }

      processing.each do |event|
        subscribers.each do |klass, block|
          block.call event if event.is_a? klass
        end
      end
    end
  end
end
