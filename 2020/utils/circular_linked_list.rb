class CircularList
  class Node
    attr_accessor :next, :data
    def initialize data
      self.data = data
      self.next = nil
    end

    def to_s
      self.data.to_s
    end
  end

  attr_accessor :head, :length

  # Initialize an empty lits.
  # Complexity: O(1).
  def initialize
    self.head   = nil
    self.length = 0
  end

  # Inserts a new node next to the specified node.
  # Complexity: O(1).
  def insert_next prev_node, data
    new_node = Node.new data
    if self.length == 0
      self.head = new_node.next = new_node
    else
      new_node.next = prev_node.next
      prev_node.next = new_node
    end
    self.length += 1

    new_node
  end

  # Inserts a new node next to the specified node.
  # Complexity: O(1).
  def insert_nexts prev_node, nodes
    nodes.last.next = prev_node.next
    prev_node.next = nodes.first
    self.length += nodes.count
  end

  def remove_nexts prev_node, count = 1
    node = prev_node
    nodes = count.times.map do
      node = node.next
    end
    prev_node.next = node.next
    self.length -= count

    nodes
  end

  # Traverse all of the elements from the list
  # without wrapping around.
  # (Starts from the head node and halts when
  # gets back to it.)
  def full_scan
    return nil unless block_given?

    current = self.head
    # If you are not familiar with ruby this
    # is the recommended way to write: do { p } while (q);
    loop do
      yield current
      current = current.next
      break if current == self.head
    end
  end

  # Prints the contents of the list.
  # Complexity: O(n).
  def to_s
    if self.length == 0
      "empty"
    else
      res = ""
      self.full_scan { |item| res += item.data.to_s + "," }
      res
    end
  end
end
