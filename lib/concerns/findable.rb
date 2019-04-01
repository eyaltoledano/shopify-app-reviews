module Concerns::Findable
  def find_by_name(name)
    self.all.find {|object| object.name == name}
  end

  def find_by_url(url)
    self.all.find {|object| object.url == url}
  end
end
