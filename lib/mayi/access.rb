module MayI
  class Access
    
    attr_accessor :implementation
    
    def initialize(implementation = nil)
      self.implementation = implementation
    end
    
    def refresh(data = {})
      raise "You have not set any implementation yet" unless self.implementation
      if self.implementation.is_a?(Class)
        Thread.current["mayi_access_implementation_#{self.object_id}"] = self.implementation.new(data)
      else
        instance = self.implementation.to_s.split('::').reduce(Object){|cls, c| cls.const_get(c) }.new(data)
        Thread.current["mayi_access_implementation_#{self.object_id}"] = instance
      end
      
    end
    
    def clear
      Thread.current["mayi_access_implementation_#{self.object_id}"] = nil
    end
    
    def current_instance
      Thread.current["mayi_access_implementation_#{self.object_id}"] || refresh
    end
    
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^(may)_.*(\?|!)$/
        if meth.to_s.end_with?("!")
          if current_instance.send(meth.to_s[0..-2].to_sym,*args)
            yield if block_given?
            true
          else
            raise_error(meth)
          end
        elsif meth.to_s.end_with?("?")
          if current_instance.send(meth.to_s[0..-2].to_sym,*args)
            yield if block_given?
            true
          else
            false
          end
        end
      else
        super(meth,*args,&block)  
      end
    end

    def respond_to?(meth)
      if meth.to_s =~ /^(may)_.*(\?|!)$/
        super(meth.to_s[0..-2].to_sym)
      else
        super(meth)  
      end
    end
    
    def error_message(message)
      Proxy.new(self) do |state|
        if state == :before
          @error_message = message
        else
          @error_message = nil
        end
      end 
    end
    
    private
    
    def raise_error(meth)
      error_message = meth.to_s[0..-2].gsub("_", " ").gsub("may","may not")
      raise AccessDeniedError.new(@error_message || error_message)
    end
    
  end
end