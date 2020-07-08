class LinkedList
  attr_accessor :list

  def initialize
    @list = []
  end

  def append(value)
    @list.append(Node.new(value))
  end

  def prepend(value)
    @list.prepend(Node.new(value))
  end

  def size
    @list.length 
  end

  def head
    @list[0]
  end

  def tail 
    @list[-1]
  end

  def at(index)
    @list[index]
  end

  def pop
    @list.pop
  end

  def contains?(value)
    return @list.includes?[value] ? true : false
  end

  def find(value)
    @list.index(value)
  end

  def to_s
    if @list.length == 0
      return "nil"
    else 
      @list.each { |node| print "( #{node.value} ) -> " }
      print "nil"
      puts ""
    end
  end

end

class Node 
  attr_accessor :value

  def initialize(value=nil, next_node=nil)
    @value = value
    @next_node = next_node
  end
end
