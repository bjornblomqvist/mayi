module MayI
  class Proxy
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(target,&block)
      @target = target
      @block = block
    end

    protected
    
    def method_missing(name, *args, &block)
      @block.call(:before)
      @target.send(name, *args, &block)
    ensure
      @block.call(:after)
    end
  end
end