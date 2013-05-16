require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MayI::Methods" do
  
  subject { TestHelper.new }
  
  context "call a may method with question mark" do
    
    it 'should call the map_do_something method' do
      subject.should_receive(:may_do_something).and_return(true)
      subject.may_do_something?.should be_true
    end
    
    it 'should yield to the block when true' do
      
      subject.should_receive(:may_do_something).and_return(true)
      has_yielded = false
      subject.may_do_something? do 
        has_yielded = true
      end
      
      has_yielded.should be_true
      
    end
    
    it 'should not yield to the block when false' do
      
      subject.should_receive(:may_do_something).and_return(false)
      has_yielded = false
      subject.may_do_something? do 
        has_yielded = true
      end
      
      has_yielded.should be_false
      
    end
    
  end
  
  context "call a may method with exclimation point " do
    
    it 'should call the map_do_something method' do
      subject.should_receive(:may_do_something).and_return(true)
      subject.may_do_something!.should be_true
    end
    
    it 'should raise an error on false' do
      subject.should_receive(:may_do_something).and_return(false)
      lambda{ subject.may_do_something! }.should raise_error(MayI::AccessDeniedError)
    end
    
    it 'should yield to the block' do
      
      subject.should_receive(:may_do_something).and_return(true)
      has_yielded = false
      subject.may_do_something! do 
        has_yielded = true
      end
      
      has_yielded.should be_true
      
    end
    
  end
  
  describe "call a may method with an error message" do
    
    it 'should set the error message for the exception' do
      
      subject.should_receive(:may_do_something).and_return(false)
      lambda{ subject.error_message("A error message").may_do_something! }.should raise_error(MayI::AccessDeniedError, "A error message")
      
    end
    
  end
  
end
