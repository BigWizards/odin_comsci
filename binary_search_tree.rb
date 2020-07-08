class Node 
  include Comparable 
  attr_accessor :value, :left_child, :right_child

  def initialize(value=nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(node)
    @value <=> node.value
  end

end

class Tree 
  attr_accessor :root, :find_result, :saved_nodes

  def initialize(array=[])
    @array = array
    @root = nil
    @find_result = nil
    @saved_nodes = []
    @parent_node = nil
    @no_block_array = []
  end

  def add_to_binary_tree(new_node, tree_node)
    # Using recursion to cycle through each node that gets added and check 
    # if the desired direction already has a child
    if tree_node.nil?
      return 
    elsif new_node == tree_node
      return
    else
      case new_node < tree_node 
      when true 
        if tree_node.left_child.nil?
          tree_node.left_child = new_node
        else
          add_to_binary_tree(new_node, tree_node.left_child)
        end
      when false
        if tree_node.right_child.nil? 
          tree_node.right_child = new_node
        else
          add_to_binary_tree(new_node, tree_node.right_child)
        end
      else
        p "Something went wrong"
      end
    end
  end

  def build_tree(array)
    #storing the new nodes in an array to be picked and iterated from when
    #adding to the node tree
    node_array = []
    array.each do |value|
      node_array << Node.new(value)
    end
    @root = node_array.slice!(0)
    node_array.each do |node|
      add_to_binary_tree(node, @root)
    end
    @root
  end

  def insert(value)
    add_to_binary_tree(Node.new(value), @root)
  end

  def save_nodes(node)
    if node.nil?
      return
    else
      @saved_nodes << node 
      save_nodes(node.left_child)
      save_nodes(node.right_child)
    end
  end

  def delete(value)
    #grabbing the node from the tree so that only a value needs to be inputted
    #split the method into save nodes to save any child nodes of the deleting node
    #and delete child which finds the node's parent and severs the connection
    delete_node = find(value, @root)
    if delete_node.nil? == false
      @saved_nodes = []
      save_nodes(delete_node)
      @saved_nodes.shift
      delete_child(delete_node, @root)
      saved_nodes.each { |node| add_to_binary_tree(node, @root) }
    end
  end

  def find(value, tree_node)
    if tree_node.nil?
      return
    elsif value == tree_node.value
      @find_result = tree_node
    else
      find(value, tree_node.left_child)
      find(value, tree_node.right_child)
      @find_result
    end
  end

  def delete_child(node, tree_node)
    if tree_node.nil?
      return
    elsif node.equal? tree_node.left_child 
      tree_node.left_child = nil
    elsif node.equal? tree_node.right_child
      tree_node.right_child = nil
    else
      delete_child(node, tree_node.left_child)
      delete_child(node, tree_node.right_child)
    end
  end

  def level_order
    queue = []
    queue << @root
    no_block_array = []
    while queue.empty? == false 
      current_node = queue.shift
      if block_given?
        yield(current_node, current_node.value)
      else
        no_block_array << current_node.value
      end
      if current_node.left_child.nil? == false
        queue << current_node.left_child
      end
      if current_node.right_child.nil? == false
        queue << current_node.right_child
      end
    end 
    if block_given? == false
      no_block_array
    end
  end

  def preorder(node=@root)
    @no_block_array = []
    if block_given?
      self.preorder_recursion(node=@root) { |node, value| puts " #{node} #{value} " }
    else
      self.preorder_recursion(node=@root)
    end
    @no_block_array
  end

  def preorder_recursion(node=@root)
    if node.nil? 
      return
    else
      if block_given?
        yield(node, node.value)
        preorder_recursion(node.left_child) { |node, value| puts " #{node} #{value} " }
        preorder_recursion(node.right_child) { |node, value| puts " #{node} #{value} " }
      else
        @no_block_array << node.value
        preorder_recursion(node.left_child) 
        preorder_recursion(node.right_child)
        @no_block_array 
      end
    end
  end

  def inorder(node=@root)
    @no_block_array = []
    if block_given?
      self.inorder_recursion(node=@root) { |node, value| puts " #{node} #{value} " }
    else
      self.inorder_recursion(node=@root)
    end
    @no_block_array
  end


  def inorder_recursion(node=@root)
    if node.nil? 
      return
    else
      if block_given?
        inorder_recursion(node.left_child) { |node, value| puts " #{node} #{value} " }
        yield(node, node.value)
        inorder_recursion(node.right_child) { |node, value| puts " #{node} #{value} " }
      else
        inorder_recursion(node.left_child)
        @no_block_array << node.value
        inorder_recursion(node.right_child) 
        @no_block_array 
      end
    end
  end

  def postorder(node=@root)
    @no_block_array = []
    if block_given?
      self.postorder_recursion(node=@root) { |node, value| puts " #{node} #{value} " }
    else
      self.postorder_recursion(node=@root)
    end
    @no_block_array
  end


  def postorder_recursion(node=@root)
    if node.nil? 
      return
    else
      if block_given?
        postorder_recursion(node.left_child) { |node, value| puts " #{node} #{value} " }
        postorder_recursion(node.right_child) { |node, value| puts " #{node} #{value} " }
        yield(node, node.value)
      else
        postorder_recursion(node.left_child)
        postorder_recursion(node.right_child)
        @no_block_array << node.value
        @no_block_array 
      end
    end
  end

  def depth(node=@root)
    if node.nil?
      return -1
    else
      left_depth = depth(node.left_child)
      right_depth = depth(node.right_child)
      return ([left_depth, right_depth].max) + 1
    end
  end

  def balanced?
    if (depth(@root.left_child) - depth(@root.right_child)).abs <= 1
      true
    else
      false
    end
  end

  def rebalance!
    build_tree(self.level_order.shuffle!)
    if self.balanced? == false
      self.rebalance!
    end
  end

  def left_rotate(node)
    temp_node = node.right_child
    node.right_child = temp_node.left_child
    temp_node.left_child = node
    return temp_node
  end
end

tree = Tree.new
script_array = Array.new(15) { rand(1..100) }
tree.build_tree(script_array)
unbalance_array = Array.new(7) { rand(101..1000) }
puts "Is the tree balanced?"
p tree.balanced?
puts ""
puts "Tree in Level order."
p tree.level_order
puts "Tree in Pre-order"
p tree.preorder
puts "Tree in order"
p tree.inorder
puts "Tree in Post-order"
p tree.postorder
puts ""
puts "adding extra elements"
unbalance_array.each { |value| tree.insert(value) }
puts "Is the tree balanced?"
p tree.balanced?
puts "Balancing tree..."
sleep 3
tree.rebalance!
puts "Is the tree now balanced?"
p tree.balanced?
puts "Tree in Level order."
p tree.level_order
puts "Tree in Pre-order"
p tree.preorder
puts "Tree in order"
p tree.inorder
puts "Tree in Post-order"
p tree.postorder
puts ""