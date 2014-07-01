module Collection
  def self.included(klass)
    klass.extend ClassMethods
  end

  def destroy
    self.class.all.delete(self)
  end

  module ClassMethods
    attr_accessor :all

    def all
      @all ||= []
    end

    def create(*args)
      all << new(*args)
      all.last
    end

    def get(index = 0)
      all[index]
    end

    def descendants
      @cache ||= begin
        ObjectSpace.each_object(Class).select do |klass|
          klass < self
        end
      end
    end
  end
end
