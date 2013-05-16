
class MayI::AccessDeniedError < RuntimeError

  def initialize(message = 'Access Denied')
    super message
  end

end
