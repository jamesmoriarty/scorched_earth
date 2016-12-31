class NullObject
  def method_missing(*_args)
    self
  end
end
