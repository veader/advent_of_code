#!/usr/bin/env ruby

require "pp"

DEBUG=false

class Spell
  attr_accessor :name, :cost, :instant_damage, :instant_healing
  attr_accessor :repeating_damage, :repeating_armor, :repeating_mana
  attr_accessor :timer, :repeats

  def initialize(name, cost=0, damage=0, healing=0, repeats=0, repeat_damage=0, repeat_armor=0, repeat_mana=0)
    self.name = name
    self.cost = cost

    # instantanious damage and healing when spell is cast
    self.instant_damage = damage
    self.instant_healing = healing

    # for repeating spells
    self.repeating_damage = repeat_damage
    self.repeating_armor = repeat_armor
    self.repeating_mana = repeat_mana

    # how many times the spell repeats and the active timer (once spell is cast)
    self.repeats = repeats
    self.timer = 0
  end

  def effect_type
    if self.repeating_damage > 0
      :damage
    elsif self.repeating_armor > 0
      :armor
    elsif self.repeating_mana > 0
      :mana
    else
      nil
    end
  end

  def cast!(attacker, defender)
    p "#{attacker.name.capitalize} casts #{self.name}." if DEBUG
    defender.defend!(self.instant_damage)
    attacker.heal!(self.instant_healing)
    attacker.use_mana(self.cost)

    if self.repeats?
      spell_dupe = self.dup # duplicate us so we don't overwrite things
      spell_dupe.timer = self.repeats
      attacker.add_active_spell(spell_dupe)
      # spell_dupe.repeat_cast!(attacker, defender) # go ahead and take first turn
    end
  end

  def repeat_cast!(attacker, defender)
    if self.repeating_damage > 0
      p "#{self.name} deals #{self.repeating_damage}; its timer is now #{self.timer-1}" if DEBUG
      defender.defend!(self.repeating_damage)
    end
    if self.repeating_armor  > 0
      p "#{self.name} provides #{self.repeating_armor} armor; its timer is now #{self.timer-1}" if DEBUG
      attacker.add_armor!(self.repeating_armor)
    end
    if self.repeating_mana   > 0
      p "#{self.name} provides #{self.repeating_mana} mana; its timer is now #{self.timer-1}" if DEBUG
      attacker.add_mana!(self.repeating_mana)
    end
    self.timer -= 1 # use a turn
  end

  def repeats?
    self.repeats > 0
  end

  def complete?
    self.timer <= 0
  end

  def print
    output = name
    output += " costs #{self.cost}. "
    if self.instant_damage > 0 || self.instant_healing > 0
      output += "It instantly"
      output += " does #{self.instant_damage} damage" if self.instant_damage > 0
      output += " and" if self.instant_damage > 0 && self.instant_healing > 0
      output += " heals you for #{self.instant_healing} hit points" if self.instant_healing > 0
      output += ". "
    end
    if self.repeats?
      output += "It starts an effect that lasts for #{self.repeats} turns. "
      output += "While it is active, your armor is increased by #{self.repeating_armor}." if self.repeating_armor > 0
      output += "At the start of each turn while it is active, it deals the boss #{self.repeating_damage} damage." if self.repeating_damage > 0
      output += "At the start of each turn while it is active, it gives you #{self.repeating_mana} new mana." if self.repeating_mana > 0
    end
    p output if DEBUG
  end
end

class Player
  attr_accessor :name, :hitpoints, :original_hitpoints, :mana, :original_mana
  attr_accessor :base_damage, :base_armor, :armor
  attr_accessor :spells, :active_spells

  def initialize(name, hp, mana, damage=0)
    self.name = name
    self.hitpoints = hp
    self.original_hitpoints = hp
    self.mana = mana
    self.original_mana = mana
    self.base_damage = damage
    self.base_armor = 0
    self.armor = 0

    self.active_spells = []

    setup_spells
  end

  def setup_spells
    self.spells = \
    [
      ["Magic Missile", 53,   4, 0, 0, 0, 0, 0],
      ["Drain",         73,   2, 2, 0, 0, 0, 0],
      ["Shield",        113,  0, 0, 6, 0, 7, 0],
      ["Poison",        173,  0, 0, 6, 3, 0, 0],
      ["Recharge",      229,  0, 0, 5, 0, 0, 101],
    ].collect do |spell_array|
      Spell.new(*spell_array)
    end
  end

  def print_spells
    self.spells.each do |spell|
      spell.print
      p "-"*10
    end
  end

  def print_status
    p "- #{self.name.capitalize} has #{self.hitpoints} hit points" + \
      ", #{self.armor} armor, #{self.mana} mana" if DEBUG
  end

  def find_spell(name)
    self.spells.find { |s| s.name == name }
  end

  # to cast a spell, we have to have enough mana and the spell can't have
  #     the same effect as an active spell
  def can_cast_spell?(name)
    return false unless spell = find_spell(name)
    spell.cost <= self.mana && !active_effects_collide?(spell)
  end

  def active_effects_collide?(spell)
    return false unless effect = spell.effect_type
    !(self.active_spells.detect { |s| s.effect_type == effect }).nil?
  end

  def attack!(player, spell=nil)
    handle_active_spells(player)
    return if self.dead_yet? || player.dead_yet?

    if self.base_damage > 0
      p "#{self.name.capitalize} attacks for #{self.base_damage} - #{player.armor} damage" if DEBUG
      player.defend!(self.base_damage)
    end
    return if self.dead_yet? || player.dead_yet?

    if spell && can_cast_spell?(spell.name)
      spell.cast!(self, player)
    end
  end

  def defend!(incoming_damage)
    self.hitpoints -= (incoming_damage - self.armor)
  end

  def heal!(added_hitpoints)
    self.hitpoints += added_hitpoints
  end

  def add_armor!(additional_armor)
    self.armor = self.base_armor + additional_armor
  end

  def add_mana!(additional_mana)
    self.mana += additional_mana
  end

  def use_mana(spell_cost)
    self.mana -= spell_cost
  end

  def add_active_spell(spell)
    self.active_spells << spell
  end

  def remove_active_spell(spell)
    self.active_spells.delete(spell)
    # we need to remove any armor buff
    add_armor!(0) if spell.effect_type == :armor
  end

  def handle_active_spells(player)
    spells_to_remove = []
    self.active_spells.each do |spell|
      spell.repeat_cast!(self, player)
      spells_to_remove << spell if spell.complete?
    end
    spells_to_remove.each do |spell|
      p "#{spell.name} wears off" if DEBUG
      remove_active_spell(spell)
    end
  end

  def dead_yet?
    # yes if we are out of hit points or mana
    self.hitpoints <= 0
  end

  def reset!
    self.hitpoints = self.original_hitpoints
    self.mana = self.original_mana
    self.armor = self.base_armor
    self.active_spells = []
  end
end

class Game
  attr_accessor :player, :boss
  attr_accessor :solutions

  def initialize
    self.player = Player.new("player", 50, 500) # use defaults
    self.boss   = Player.new("boss", 71, 0, 10) # from puzzle input
    self.solutions = {} # hash to hold mana used and possible solutions
  end

  # returns winner and amount of mana used
  def play!(spells_to_cast=[])
    orig_spells_cast = spells_to_cast.dup
    attacker = self.boss
    defender = self.player

    attacker.reset!
    defender.reset!
    original_mana = self.player.mana
    spell_cost = 0

    until defender.dead_yet?
      attacker, defender = defender, attacker # switch roles
      p "-- #{attacker.name.capitalize} turn --" if DEBUG
      self.player.print_status
      self.boss.print_status

      # pop a spell off the stack for the player each time
      spell = nil
      if attacker == self.player && self.player.can_cast_spell?(spells_to_cast.first)
        spell = self.player.find_spell(spells_to_cast.shift)
        spell_cost += spell.cost
      end
      defender.handle_active_spells(attacker)
      attacker.attack!(defender, spell)
      p "" if DEBUG
    end

    winner = attacker
    if DEBUG || winner == self.player
      p ""
      p "#{winner.name.capitalize} wins! (and still has #{winner.hitpoints} HP) " + \
        "Player used #{spell_cost} mana " + \
        "> #{orig_spells_cast}"
    else
      print "."
    end

    [winner, spell_cost]
  end

  # attempt to find
  def find_possible_solutions(number_of_spells_to_cast=spells.count)
    self.solutions = {}

    # 1.upto(number_of_spells_to_cast) do |num_spells|
      num_spells = number_of_spells_to_cast
      spell_combos(num_spells).each do |combo|
        p "=" * 80 if DEBUG
        winner, mana_used = play!(combo.dup)
        if winner == self.player
          solutions[mana_used] ||= []
          solutions[mana_used] << combo
        end
      end
    # end

    p ""
    p "Possible Solutions"
    pp solutions
  end

  # return array of all combinations of spells
  def spell_combos(num_spells, combo=[])
    return [combo] if num_spells == 0

    spells = self.player.spells.collect(&:name)

    final_combos = []
    spells.each do |spell|
      final_combos += spell_combos(num_spells-1, combo+[spell])
    end
    final_combos
  end

end

# ============================================================================
if __FILE__ == $0
  spell_count = (ARGV[0] || 5).to_i
  game = Game.new
  game.find_possible_solutions(spell_count)
end
