class SpaceCards
  def initialize(decks)
    @decks = decks
    @rounds_history = []
  end

  def round
    cards = @decks.map(&:shift)
    if cards.each_with_index.all?{|card, index| card <= @decks[index].count}
      winner = play_sub_game(cards)
    else
      winner = cards.index(cards.max)
    end
    winner_s_card = cards[winner]
    @decks[winner] += [winner_s_card, *(cards - [winner_s_card])]
  end

  def play!
    while @decks.select{|deck| deck.count > 0}.count > 1
      return 0 if already_played?
      round
    end
    winner = @decks.find(&:any?)
    @decks.index(winner)
  end

  def score(winner)
    deck = @decks[winner]
    deck.reverse.each_with_index.map{|card, index| card * (index + 1)}.sum
  end

  private

  def already_played?
    if @rounds_history.include?(@decks)
      return true
    end
    @rounds_history << @decks.map(&:dup)
    false
  end

  def play_sub_game(cards)
    new_decks = @decks.each_with_index.map { |deck, index| deck[0...cards[index]] }
    sub_game = SpaceCards.new(new_decks)
    sub_game.play!
  end
end

if __FILE__ == $0
  input = File.read('22_input.txt')
  players = input.split("\n\n")
  players_cards = players.map{ |data| data.split("\n")[1..-1].map(&:to_i) }
  game = SpaceCards.new(players_cards)

  winner = game.play!
  p game.score(winner)
end
