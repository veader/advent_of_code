#!/usr/bin/env ruby

require "pp"

DEBUG=false
WINNING=false # true for *, false for **

# ============================================================================
class StoreItem
  attr_accessor :name, :cost, :defense, :attack

  def initialize(input="")
    return nil if parse(input).nil?
  end

  def parse(input="")
    return nil if input.match(/:/) # ignore header lines
    pieces = input.split.reverse
    self.defense = pieces.shift.to_i
    self.attack  = pieces.shift.to_i
    self.cost    = pieces.shift.to_i
    self.name = pieces.reverse.join(" ")
  end

  def as_string
    "(#{self.name} $#{self.cost} ATTACK:#{self.attack} DEFENSE:#{self.defense})"
  end
end

# ============================================================================
class Store
  attr_accessor :weapons, :armor, :rings

  def initialize
    self.weapons = []
    self.armor = []
    self.rings = []
    parse_store_data
  end

  def parse_store_data
    what_it_is = nil
    File.readlines("./store.txt").each do |line|
      next if line.chomp.strip.empty?
      if match = line.match(/^(\S+):/)
        what_it_is = match.captures.first.downcase.to_sym
      else
        item = StoreItem.new(line.chomp)
        self.send(what_it_is).push(item)
      end
    end
  end

  def print
    p "Weapons:"
    pp self.weapons
    p "Armor:"
    pp self.armor
    p "Rings:"
    pp self.rings
  end
end

# ============================================================================
class Player
  attr_accessor :name, :hitpoints, :original_hitpoints
  attr_accessor :base_attack, :attack
  attr_accessor :base_defense, :defense
  attr_accessor :armor, :weapon, :rings

  def initialize(name, hp=100, attack=0, defense=0)
    self.name = name

    self.hitpoints = hp
    self.original_hitpoints = hp

    self.base_defense = defense
    self.defense = defense
    self.base_attack = attack
    self.attack = attack

    self.rings = []
  end

  def attack!(player)
    player.defend!(self)
  end

  def defend!(player)
    damage_taken = player.attack - self.defense
    damage_taken = 1 if damage_taken < 1
    self.hitpoints -= damage_taken
    self.hitpoints = 0 if self.hitpoints < 0
    p "The #{player.name} deals #{player.attack}-#{self.defense}=#{damage_taken} damage;" + \
     " the #{self.name} goes down to #{self.hitpoints} hit points." if DEBUG
  end

  def dead_yet?
    self.hitpoints == 0
  end

  def revive!
    self.hitpoints = self.original_hitpoints
  end

  def reset!
    revive!
    self.rings   = []
    equip_weapon(nil)
    equip_armor(nil)
  end

  def equip_weapon(weapon)
    self.weapon = weapon
    adjust_attack
  end

  def equip_armor(armor)
    self.armor = armor
    adjust_defense
  end

  def equip_ring(ring)
    self.rings << ring
    adjust_defense
    adjust_attack
  end

  def adjust_attack
    new_attack = self.base_attack
    new_attack += self.weapon.attack if self.weapon
    new_attack += self.rings.collect(&:attack).reduce(:+) unless self.rings.empty?
    self.attack = new_attack
  end

  def adjust_defense
    new_defense = self.base_defense
    new_defense += self.armor.defense if self.armor
    new_defense += self.rings.collect(&:defense).reduce(:+) unless self.rings.empty?
    self.defense = new_defense
  end

  def print
    p "#{self.name} HP: #{self.hitpoints} ATTACK: #{self.attack} DEFENSE: #{self.defense}"
    output = "Equipped: "
    output += "WEAPON: #{self.weapon.as_string}" if self.weapon
    output += "ARMOR: #{self.armor.as_string}" if self.armor
    output += "RINGS: [#{self.rings.collect(&:as_string).join(',')}]" unless self.rings.empty?
    p output unless output.strip.empty?
  end
end

# ============================================================================
class Game
  attr_accessor :player, :boss, :store

  def initialize
    self.player = Player.new("player") # use defaults
    self.boss = Player.new("boss", 100, 8, 2) # from puzzle input
    self.store = Store.new
  end

  def optimize_gear_purchases_for_win
    costs = {}

    0.upto(1) do |armor_count|
      0.upto(2) do |ring_count|
        results = test_combinations(armor_count, ring_count)
        costs.merge!(results)
      end
    end

    puts ""
    if WINNING
      cheapest = costs.keys.compact.sort.first
      p "Cheapest Combo => $#{cheapest}"
      pp costs[cheapest].uniq
    else
      most_expensive = costs.keys.compact.sort.last
      p "Most Expensive Combo => $#{most_expensive}"
      pp costs[most_expensive].uniq
    end
  end

  def test_combinations(armor_count=0, ring_count=0)
    costs = {}

    use_weapon = nil
    use_armor  = nil
    use_rings  = []

    self.store.weapons.each do |weapon|
      use_weapon = weapon # must use a weapon

      self.store.armor.each do |armor|
        # use each piece of armor, if we are equipping armor
        use_armor = armor if armor_count != 0

        self.store.rings.each do |ring1|
          # use a ring, if we are equipping at least 1 ring
          use_rings << ring1 if ring_count > 0

          self.store.rings.each do |ring2|
            next if use_rings.include?(ring2) # can't equip the same ring twice
            # use a second ring, if we are equipping 2 rings
            use_rings << ring2 if ring_count > 1

            if winning_combination?(use_weapon, use_armor, use_rings)
              items = ([use_weapon, use_armor] + use_rings).compact
              cost = items.collect(&:cost).reduce(:+)
              costs[cost] ||= []
              costs[cost] << items unless costs[cost].include?(items)
            end

            use_rings.delete(ring2)
          end
          use_rings.delete(ring1)
        end
      end
    end

    costs
  end

  def winning_combination?(weapon=nil, armor=nil, rings=[])
    self.player.equip_weapon(weapon)
    self.player.equip_armor(armor)
    rings.each { |r| self.player.equip_ring(r) }

    winner = play!
    self.player.reset!
    (winner == self.player) == WINNING
  end

  # returns winner
  def play!
    attacker = self.boss
    defender = self.player

    attacker.revive!
    defender.revive!

    until defender.dead_yet?
      attacker, defender = defender, attacker # switch roles
      attacker.attack!(defender)
    end

    if DEBUG
      p "#{attacker.name.capitalize} wins! (and still has #{attacker.hitpoints} HP)"
    else
      print "."
    end
    attacker
  end

  def reset!
    self.boss.revive!
    self.player.revive!
  end
end

# ============================================================================
if __FILE__ == $0
  game = Game.new
  game.optimize_gear_purchases_for_win
end
