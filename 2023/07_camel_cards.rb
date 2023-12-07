class Card
  CARDS = %w(J 2 3 4 5 6 7 8 9 10 T Q K A)

  attr_reader :card

  def initialize(card)
    raise "Invalid card: #{card}" unless CARDS.include?(card)

    @card = card
  end

  def <=>(other)
    strength <=> other.strength
  end

  def strength
    CARDS.index(@card)
  end
end

class Hand
  attr_accessor :rank
  attr_reader :cards, :bid
  def initialize(cards, bid = 0)
    @cards = cards.map{|card| Card.new(card)}
    @bid = bid
  end

  def gains
    @bid * @rank
  end

  def score
    card_score = @cards.map(&:strength)

    [combination_score, card_score]
  end

  def combination_score

    # find best possible score
    jokers_count = @cards.count{|card| card.card == "J"}
    if jokers_count > 0
      return Card::CARDS[1..].repeated_combination(jokers_count).map do |joker_cards|
        cards = @cards.map(&:card).map do |card|
          next joker_cards.shift if card == "J"

          card
        end
        Hand.new(cards).combination_score
      end.max
    end

    combination_score = case pattern
    when [5] # Five of a kind
      10
    when [4, 1] # Four of a kind
      9
    when [3, 2] # Full house
      8
    when [3, 1, 1] # Three of a kind
      7
    when [2, 2, 1] # Two pairs
      6
    when [2, 1, 1, 1] # One pair
      5
    when [1, 1, 1, 1, 1] # High card
      4
    else
      raise "Absurd!"
    end
  end

  def <=>(other)
    score <=> other.score
  end

  private

  def pattern
    @cards.group_by(&:strength).values.map(&:size).sort.reverse
  end
end

if __FILE__ == $0
  filename = "07_input.txt"
  lines = File.readlines(filename, chomp: true)

  hands = lines.map do |line|
    cards, bid = line.split(/ +/)
    Hand.new(cards.split(""), bid.to_i)
  end
  hands.sort.each_with_index do |hand, index|
    hand.rank = index + 1
    # print "(#{hand.cards.map(&:card).join("")}) #{hand.rank} * #{hand.bid} (score: #{hand.score}\n"
  end

  p hands.sum(&:gains)
end
