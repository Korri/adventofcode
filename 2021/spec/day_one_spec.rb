require_relative '../01_star_counter'

RSpec.describe StarCounter do
  describe '#find_pairs' do
    it "returns the pair that gives 2020" do
      counter = StarCounter.new([100, 450, 732, 1570])

      expect(counter.find_entries).to eq [450, 1570]
    end
    it "returns the pair that gives 2020 in a consistent order" do
      counter = StarCounter.new([100, 1570, 450, 732])

      expect(counter.find_entries).to eq [450, 1570]
    end
    it "returns nil if nothing matches" do
      counter = StarCounter.new([100, 1570, 455, 732])

      expect(counter.find_entries).to be_nil
    end
  end
end
