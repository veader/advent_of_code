#!/usr/bin/env ruby

require "pp"
require_relative "day22"

player = Player.new("test", 100, 0)

spell_name = "Poison"
raise "Should not be able to cast spell with 0 mana" if player.can_cast_spell?(spell_name)
player.mana = 200
raise "Should be able to cast spell." unless player.can_cast_spell?(spell_name)
spell = player.find_spell(spell_name)
player.active_spells = [spell]
raise "Should not be able to stack damage effect" if player.can_cast_spell?(spell_name)

spell_name = "Sheild"
spell = player.find_spell(spell_name)
player.active_spells = [spell]
raise "Should not be able to stack armor effect" if player.can_cast_spell?(spell_name)

spell_name = "Recharge"
spell = player.find_spell(spell_name)
player.active_spells = [spell]
raise "Should not be able to stack mana effect" if player.can_cast_spell?(spell_name)


game = Game.new
game.player.original_hitpoints = 10
game.player.original_mana = 250
game.boss.original_hitpoints = 13
game.boss.base_damage = 8
## EXAMPLE 1
# game.play!(["Poison", "Magic Missile"])

## EXAMPLE 2
# game.boss.original_hitpoints = 14
# game.play!(["Recharge", "Shield", "Drain", "Poison", "Magic Missile"])

# pp game.spell_combos(2)
# pp game.player.spells.collect(&:name).permutation.to_a

DEBUG=true
game2 = Game.new
winner, mana_used = game2.play!(["Shield", "Drain", "Recharge", "Poison", "Poison", "Recharge", "Poison", "Poison"])
p "Won by #{winner} and used #{mana_used} mana"
