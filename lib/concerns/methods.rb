module Concerns::Methods
  module InstanceMethods
    def save
      self.class.all << self
    end
  end

  module ClassMethods
    def create(attributes)
      self.new(attributes).tap{ |a| a.save }
    end

    def destroy_all
      self.class.all.clear
    end
  end
end
