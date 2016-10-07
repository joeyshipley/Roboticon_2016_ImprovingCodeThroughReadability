class Character
  attr_accessor :c_name, :c_class, :c_lvl, :c_hp, :c_evade
  attr_accessor :armor, :weapon

  def initialize
    @c_name = 'Sir Joseph'
    @c_class = 'Knight'
    @c_lvl = 2
    @c_hp = 20
    @c_evade = 5 # 5% chance to reduce damage after resistances/def are calculated by 1/2
    @c_counter = 2 # 2% chance to counter an attack
    @armor = 'Leather'
    @weapon = 'Longsword'
  end

  # d_type = the type of damage
  # dmg = amount of damage attempting to deal
  # ap = how well it penetrates armor
  # srpe_att (bool) = was it a surprise attack?
  # char_att = the attacking character
  def dmg( d_type, dmg, ap, srpe_att, char_att )
    d = dmg

    # surprise attacks do more damage
    if srpe_att
      d = d * 1.5
    end

    # when you see it coming, there is a chance that you get to evade part of the damage
    if !srpe_att && (rand(100) + 1 < @c_evade)
      d = d / 1.25; # consider redesigning this feature, the original value was way to strong, temp reducing the divider
    end

    # modify damage based on your resistances to the different types
    case d_type
      when :standard
        d -= @c_class == 'Knight' ? 10 : 0 # Warriors get a special resistance to standard damage
      when :magic
        d -= @c_class == 'Wizard' ? 10 : 1 # Magi get a special resistance to magic damage
      when :earth
        d -= 1
      when :fire
        d -= 1
      when :water
        d -= 1
      when :wind
        d -= 1
      when :shadow
        d -= @c_class == 'Shinobi' ? 10 : 1 # Rogue get a special resistance to shadow damage
      when :ice
        d -= 1
      when :lightning
        d -= 1
      when :dark
        d -= 1
      when :light
        d -= 1
      when :psionic
        d -= 1
      else
        d -= 0
    end

    # modify damage based on armor worn
    if @armor == 'Leather'
      unless srpe_att # characters don't get to use armor values when surprise attacked
        d -= (2 - ap)
      end
    elsif @armor == 'Chain mail'
      unless srpe_att # characters don't get to use armor values when surprise attacked
        d -= (6 - ap)
      end
    elsif @armor == 'Full Plate'
      unless srpe_att # characters don't get to use armor values when surprise attacked
        d -= (12 - ap)
      end
    end

    # make sure we don't give them hp when they block it
    if d < 0
      d = 0;
    end

    # apply the damage
    @c_hp = @c_hp - d

    # display results
    if d == 0
      puts 'You suffered no damage from the attack, way to go!'
    elsif @c_hp <= 0
      @c_lvl -= 1
      puts "You #{ @c_name } have perished. You respawn back at town square but have suffered loss in level. You are now level #{ @c_lvl }"
    else
      puts "You have suffered #{ d } wounds and now have #{ @c_hp } health left"
    end

    # NOTE: this is becoming to painful, removing until we figure out
    # how to handle all the different combos for the counter attack
    # if @c_hp > 0 && !srpe_att && (rand(100) + 1 < @c_counter)
    #   if @c_class == 'Knight' && @weapon == 'Short Sword'
    #     char_att.dmg(:physical, rand(10) + 2, 0, false)
    #   end
    #   if @c_class == 'Knight' && @weapon == 'Longsword'
    #     char_att.dmg(:physical, rand(20) + 2, 0, false)
    #   end
    #   if @c_class == 'Knight' && @weapon == 'Battle Axe'
    #     char_att.dmg(:physical, rand(11) + 10, 0, false)
    #   end
    #   if @c_class == 'Wizard' && @weapon == 'Fireball'
    #     char_att.dmg(:fire, rand(10) + 6, 0, false)
    #   end
    #   if @c_class == 'Wizard' && @weapon == 'Ice Spikes'
    #     char_att.dmg(:ice, rand(10) + 6, 0, false)
    #   end
    #   if @c_class == 'Wizard' && @weapon == 'Crushing Grasp'
    #     char_att.dmg(:magic, rand(10) + 6, 0, false)
    #   end
    #   if @c_class == 'Shinobi' && @weapon == 'Tanto'
    #     char_att.dmg(:magic, rand(6) + 6, 6, false)
    #   end
    #   if @c_class == 'Shinobi' && @weapon == 'Ninjato'
    #     char_att.dmg(:magic, rand(12) + 6, 3, false)
    #   end
    # end
  end
end
