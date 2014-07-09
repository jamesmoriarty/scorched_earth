class GameObject
  def update
  end

  def render(win, height)
  end

  def destroy
    self.class.all.delete(self)
  end

  class << self
    def all
      @collection ||= []
    end

    def get(index = 0)
      @collection[index]
    end

    def create(*args)
      all << new(*args)
      all.last
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
