class SpaceCards
  def initialize(decks)
    @decks = decks
  end

  def round
    cards = @decks.map(&:shift)
    non_nil_cards = cards.select.to_a
    winner = cards.index(non_nil_cards.max)
    @decks[winner] += non_nil_cards.sort.reverse
  end

  def play!
    while @decks.select{|deck| deck.count > 0}.count > 1
      round
    end
    @decks.find(&:any?)
  end

  def self.score(winner)
    winner.reverse.each_with_index.map{|card, index| card * (index + 1)}.sum
  end
end

if __FILE__ == $0
  input = File.read('22_input.txt')
  players = input.split("\n\n")
  players_cards = players.map{ |data| data.split("\n")[1..-1].map(&:to_i) }
  game = SpaceCards.new(players_cards)

  winner = game.play!
  p SpaceCards.score(winner)
end
