
module MayI
  
  def method_missing(meth, *args, &block)
    if is_a_may_i_method?(meth)
      if self.send(meth.to_s[0..-2].to_sym,*args)
        yield if block_given?
        true
      else
        meth.to_s.end_with?("!") ? raise_may_i_error(meth) : false
      end
    else
      super(meth,*args,&block)  
    end
  ensure
    @may_i_error_message = nil
  end

  def respond_to?(meth)
    if is_a_may_i_method?(meth)
      super(meth.to_s[0..-2].to_sym)
    else
      super(meth)  
    end
  end

  def error_message(message)
    @custom_may_i_error_message = message
    self
  end

  private
  
  def is_a_may_i_method?(sym)
    sym.to_s.match(/^(may)_.*(\?|!)$/)
  end

  def raise_may_i_error(meth)
    raise MayI::AccessDeniedError.new(@custom_may_i_error_message || meth.to_s[0..-2].gsub("_", " ").gsub("may","may not"))
  end
  
end