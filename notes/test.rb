require '../lib/colorize'
require './player'

def test_game
  @home_aggregate = 0
  @home_max = 0
  @away_aggregate = 0
  @away_max = 0

  def reset_game
    reset_out_count
    reset_score
    reset_pitch_count
    reset_pitches_thrown_counts
  end
  def reset_score
    @home_score = 0
    @away_score = 0
  end

  def reset_pitch_count
    @ball_count = 0
    @strike_count = 0
  end

  def reset_pitches_thrown_counts
    @home_pitches_thrown = 0
    @away_pitches_thrown = 0
  end

  def reset_out_count
    @out_count = 0
  end

  def print_pitch_count
    puts (@ball_count.to_s + "-" + @strike_count.to_s).light_black
  end

  def print_outs
    # outs = "  "
    # @out_count.times do
    #   outs += IS_OUT.encode('utf-8') + ' '
    # end
    # (3-@out_count).times do
    #   outs += NOT_OUT.encode('utf-8') + ' '
    # end
    # puts outs
  end

  def print_score
    puts 'PITCH COUNTS'
    puts ' ' + @home_pitches_thrown.to_s + '     ' + @away_pitches_thrown.to_s
    puts 'HOM   AWA'
    puts ' ' + @home_score.to_s + '     ' + @away_score.to_s
  end

  def call_swinging_strike(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    puts ('Swing and a miss!').light_blue
    add_one_to(partial_defense_key.concat("Strikes"))
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    add_one_to(partial_defense_key.concat("Pitches"))
    @strike_count += 1
  end

  def call_strike(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    puts ('Strike!').light_blue
    add_one_to(partial_defense_key.concat("Strikes"))
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    add_one_to(partial_defense_key.concat("Pitches"))
    @strike_count += 1
  end

  def call_ball(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    puts ('Ball!!').light_blue
    add_one_to(partial_defense_key.concat("Balls"))
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    add_one_to(partial_defense_key.concat("Pitches"))
    @ball_count += 1
  end

  def call_foul(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    puts ('Hit!').light_red
    puts ('Its in the air...').light_green
    puts ('Foul ball!').cyan
    add_one_to(partial_offense_key.concat("Foul Balls"))
    add_one_to(partial_defense_key.concat("Pitches"))
    @strike_count += 1 if @strike_count < 2
  end

  def check_strikeout
    return true if @strike_count === 3
    return false
  end

  def check_walk
    return true if @ball_count === 4
    return false
  end

  def score_run_home
    @home_score += 1
    @home_aggregate += 1
  end

  def score_run_away
    @away_score += 1
    @away_aggregate += 1
  end

  def finish_at_bat
    reset_pitch_count
    print_outs
    print_bases
  end

  def add_one_to(key)
    @records[key] += 1
  end

  def hit_sequence(top_of_inning, batter_rating)
    if !top_of_inning
      hit_is_ground = rand(HOME_HITS_PER_TEN_FLY) > 10
      ground_fielding_rating = AWAY_GROUND_FIELDING_RATING_BASE*FIELDER_RATIO + rand(GROUND_FIELDING_RATING_MODIFIER)
      fly_fielding_rating = AWAY_FLY_FIELDING_RATING_BASE*FIELDER_RATIO + rand(FLY_FIELDING_RATING_MODIFIER)
      power = rand(HOME_SINGLE_RATIO+HOME_DOUBLE_RATIO+HOME_TRIPLE_RATIO+HOME_HOMERUN_RATIO)
      homerun_cutoff = HOME_SINGLE_RATIO+HOME_DOUBLE_RATIO+HOME_TRIPLE_RATIO
      triple_cutoff = HOME_SINGLE_RATIO+HOME_DOUBLE_RATIO
      double_cutoff = HOME_SINGLE_RATIO
      double_play_rating = AWAY_DOUBLE_PLAY_RATING_BASE + rand(DOUBLE_PLAY_RATING_MODIFIER)
    else
      hit_is_ground = rand(AWAY_HITS_PER_TEN_FLY) > 10
      ground_fielding_rating = HOME_GROUND_FIELDING_RATING_BASE*FIELDER_RATIO + rand(GROUND_FIELDING_RATING_MODIFIER)
      fly_fielding_rating = HOME_FLY_FIELDING_RATING_BASE*FIELDER_RATIO + rand(FLY_FIELDING_RATING_MODIFIER)
      power = rand(AWAY_SINGLE_RATIO+AWAY_DOUBLE_RATIO+AWAY_TRIPLE_RATIO+AWAY_HOMERUN_RATIO)
      homerun_cutoff = AWAY_SINGLE_RATIO+AWAY_DOUBLE_RATIO+AWAY_TRIPLE_RATIO
      triple_cutoff = AWAY_SINGLE_RATIO+AWAY_DOUBLE_RATIO
      double_cutoff = AWAY_SINGLE_RATIO
      double_play_rating = HOME_DOUBLE_PLAY_RATING_BASE + rand(DOUBLE_PLAY_RATING_MODIFIER)
    end

    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end

    if hit_is_ground
    # If Ground Hit
      if batter_rating >= ground_fielding_rating
      # Successful Ground Hit
        if power > double_cutoff
          puts ('Hit!').light_red
          puts ('On the ground...').light_green
          add_one_to(partial_offense_key.concat("Groundballs"))
          hit(top_of_inning,2)
          finish_at_bat
        else
          puts ('Hit!').light_red
          puts ('On the ground...').light_green
          add_one_to(partial_offense_key.concat("Groundballs"))
          hit(top_of_inning,1)
          finish_at_bat
        end
      elsif (double_play_rating > rand(DOUBLE_PLAY_NEEDED)) && @man_on_first_base
      # Double Play
        if @out_count === 2
          puts ('Hit!').light_red
          puts ('On the ground...').light_green
          puts ('The throw is in time!').light_red
          add_one_to(partial_defense_key.concat("Throwouts"))
          @out_count += 1
          advance_batters(top_of_inning)
          finish_at_bat
        else
          puts ('Hit!').light_red
          puts ('On the ground...').light_green
          puts ('Double play!').light_red
          add_one_to(partial_defense_key.concat("Double Plays"))
          add_one_to(partial_defense_key)
          @out_count += 2
          advance_batters(top_of_inning)
          @man_on_second_base = false
          finish_at_bat
        end

      else
      # Out at First
        puts ('Hit!').light_red
        puts ('On the ground...').light_green
        puts ('The throw is in time!').light_red
        add_one_to(partial_defense_key.concat("Throwouts"))
        @out_count += 1
        advance_batters(top_of_inning)
        finish_at_bat
      end
    else
    # If Fly Ball
      if batter_rating >= fly_fielding_rating
      # Successful Hit
        if power > homerun_cutoff
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          add_one_to(partial_offense_key.concat("Flyballs"))
          hit(top_of_inning,4)
          finish_at_bat
        elsif power > triple_cutoff
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          add_one_to(partial_offense_key.concat("Flyballs"))
          hit(top_of_inning,3)
          finish_at_bat
        elsif power > double_cutoff
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          add_one_to(partial_offense_key.concat("Flyballs"))
          hit(top_of_inning,2)
          finish_at_bat
        else
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          add_one_to(partial_offense_key.concat("Flyballs"))
          hit(top_of_inning,1)
          finish_at_bat
        end
      else
      # Caught
        if power > double_cutoff
        # Runners Still Tag Up
          @out_count += 1
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          puts ('It\'s caught!').light_red
          add_one_to(partial_defense_key.concat("Catches"))
          if @out_count < 3 && (@man_on_first_base || @man_on_second_base || @man_on_third_base)
            puts ('Runners tag up and advance!').light_green
            advance_batters(top_of_inning)
          end
          finish_at_bat
        else
          puts ('Hit!').light_red
          puts ('Its in the air...').light_green
          puts ('It\'s caught!').light_red
          add_one_to(partial_defense_key.concat("Catches"))
          @out_count += 1
          finish_at_bat
        end
      end
    end

  end

  def hit(top_of_inning,bases_gained)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end

    if bases_gained === 4 && @man_on_first_base && @man_on_second_base && @man_on_third_base
      puts ('- - - - - > GRANDSLAM!').light_green
      add_one_to(partial_offense_key.concat("Grandslams"))
    elsif bases_gained === 4
      puts ('- - - - > HOMERUN!').light_green
      add_one_to(partial_offense_key.concat("Homeruns"))
    end

    advance_batters(top_of_inning)
    @man_on_first_base = true

    case bases_gained
    when 4

      3.times {advance_batters(top_of_inning)}
    when 3
      puts ('- - - > TRIPLE!').light_green
      add_one_to(partial_offense_key.concat("Triples"))
      2.times {advance_batters(top_of_inning)}
    when 2
      puts (' - - > DOUBLE!').light_green
      add_one_to(partial_offense_key.concat("Doubles"))
      advance_batters(top_of_inning)
    when 1
      puts ('- > SINGLE!').light_green
      add_one_to(partial_offense_key.concat("Singles"))
    else
      puts ('ERROR IN HIT(BASES_GAINED)').light_red
    end

    reset_pitch_count
    print_outs

  end

  def advance_batters(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end

    if @man_on_third_base
      score_run_home if !top_of_inning
      score_run_away if top_of_inning
      add_one_to(partial_offense_key.concat("Runs"))
    end
    if @man_on_second_base
      @man_on_third_base = true
      @man_on_second_base = false
    else
      @man_on_third_base = false
    end
    if @man_on_first_base
      @man_on_second_base = true
      @man_on_first_base = false
    else
      @man_on_second_base = false
    end
    @man_on_first_base = false
  end

  def walk(top_of_inning)
    #need to fix walk so batters dont advance if unnecessary

    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    puts ('WALK!').light_blue
    add_one_to(partial_defense_key.concat("Walks"))
    add_one_to(partial_offense_key.concat("Walked"))
    advance_batters(top_of_inning)
    @man_on_first_base = true
    reset_pitch_count
    print_outs
    print_bases
  end

  def strikeout(top_of_inning)
    if top_of_inning
      partial_defense_key = "Home "
      partial_offense_key = "Away "
    else
      partial_defense_key = "Away "
      partial_offense_key = "Home "
    end
    @out_count += 1
    puts ('STRIKEOUT!').light_red
    add_one_to(partial_defense_key.concat("Strikeouts"))
    reset_pitch_count
    print_outs
    print_bases
  end

  def pitch_and_swing(top_of_inning)
    puts ('Here comes the pitch...').light_blue
    if @current_inning > 9
      if !top_of_inning
        pitcher_rating = rand(AWAY_PITCHER_RATING_BASE*PITCHER_RATIO + PITCHER_RATING_MODIFIER) + [@away_pitching_stamina,@away_pitching_stamina/5].max - @current_inning*INNING_MULTIPLIER
      else
        pitcher_rating = rand(HOME_PITCHER_RATING_BASE*PITCHER_RATIO + PITCHER_RATING_MODIFIER) + [@home_pitching_stamina,@home_pitching_stamina/5].max - @current_inning*INNING_MULTIPLIER
      end
    else
      if !top_of_inning
        pitcher_rating = rand(AWAY_PITCHER_RATING_BASE*PITCHER_RATIO + PITCHER_RATING_MODIFIER) + [@away_pitching_stamina,@away_pitching_stamina/5].max
      else
        pitcher_rating = rand(HOME_PITCHER_RATING_BASE*PITCHER_RATIO + PITCHER_RATING_MODIFIER) + [@home_pitching_stamina,@home_pitching_stamina/5].max
      end
    end

    if !top_of_inning
      pitcher_standard = rand(AWAY_PITCHER_RATING_BASE*AWAY_BALL_RATIO) + [@away_pitching_stamina,@away_pitching_stamina/5].max
      batter_rating = rand(HOME_BATTER_RATING_BASE*BATTER_RATIO + BATTER_RATING_MODIFIER)
    else
      pitcher_standard = rand(HOME_PITCHER_RATING_BASE*HOME_BALL_RATIO) + [@home_pitching_stamina,@home_pitching_stamina/5].max
      batter_rating = rand(AWAY_BATTER_RATING_BASE*BATTER_RATIO + BATTER_RATING_MODIFIER)
    end

    update_pitcher_stamina(top_of_inning)
    if pitcher_rating < pitcher_standard
      call_ball(top_of_inning)
      print_pitch_count
      walk(top_of_inning) if check_walk
    elsif pitcher_rating > batter_rating

      if batter_rating*1.25 > pitcher_rating
        call_foul(top_of_inning)
        print_pitch_count
      else
        call_strike(top_of_inning)
        print_pitch_count
        strikeout(top_of_inning) if check_strikeout
      end
    elsif pitcher_rating* 1.25 > batter_rating
        call_swinging_strike(top_of_inning)
    else

      hit_sequence(top_of_inning, batter_rating)
    end
  end

  def update_pitcher_stamina(top_of_inning)
    if !top_of_inning
      @away_pitching_stamina -= 1
      @away_pitches_thrown += 1
    else
      @home_pitching_stamina -= 1
      @home_pitches_thrown += 1
    end
  end

  def clear_bases(top_of_inning)
    if top_of_inning
      partial_key = "Home "
    else
      partial_key = "Away "
    end
    partial_key = partial_key.concat("RLOB")

    add_one_to(partial_key) if @man_on_first_base
    @man_on_first_base = false
    add_one_to(partial_key) if @man_on_second_base
    @man_on_second_base = false
    add_one_to(partial_key) if @man_on_third_base
    @man_on_third_base = false
  end

  def print_bases
    # if @man_on_first_base
    #   first_base = MAN_ON_BASE
    # else
    #   first_base = EMPTY_BASE
    # end
    # if @man_on_second_base
    #   second_base = MAN_ON_BASE
    # else
    #   second_base = EMPTY_BASE
    # end
    # if @man_on_third_base
    #   third_base = MAN_ON_BASE
    # else
    #   third_base = EMPTY_BASE
    # end
    #
    # puts '    ' + second_base.encode('utf-8')
    # puts '  ' + third_base.encode('utf-8') + '   ' + first_base.encode('utf-8')

    out_line_1 = "  "
    out_line_2 = "        "
    @out_count.times do
      out_line_1 += IS_OUT.encode('utf-8') + ' '
    end
    (3-@out_count).times do
      out_line_1 += NOT_OUT.encode('utf-8') + ' '
    end

    if @man_on_first_base
      first_base = MAN_ON_BASE
    else
      first_base = EMPTY_BASE
    end
    if @man_on_second_base
      second_base = MAN_ON_BASE
    else
      second_base = EMPTY_BASE
    end
    if @man_on_third_base
      third_base = MAN_ON_BASE
    else
      third_base = EMPTY_BASE
    end

    out_line_1 += ' |    ' + second_base.encode('utf-8')
    out_line_2 += ' |  ' + third_base.encode('utf-8') + '   ' + first_base.encode('utf-8')

    puts "\n"
    puts out_line_1
    puts out_line_2
    puts "\n"

  end

  def end_inning(top_of_inning)
    @total_innings += 1
    reset_out_count
    clear_bases(top_of_inning)
    print_score

    @away_is_batting ? @away_is_batting = false : @away_is_batting = true

    print_stats
  end

  def declare_winner
    if @home_score > @away_score
      puts (HOM+' WINS IN THE ' + (@current_inning-1).to_s + 'TH! ' +  @home_score.to_s + '-' + @away_score.to_s).magenta
      @home_wins += 1
      add_one_to("Home Wins")
    end
    if @home_score < @away_score
      puts (AWA+' WINS IN THE ' + (@current_inning-1).to_s + 'TH! ' +  @away_score.to_s + '-' + @home_score.to_s).magenta
      @away_wins += 1
      add_one_to("Away Wins")
    end
    if @home_score === @away_score
      puts ('TIE GAME???').magenta
      @ties += 1
    end
  end

  def print_team_stats(title, home_stat, away_stat)
    puts (title + "\t" + home_stat + "\t" + away_stat + "\t" + (home_stat.to_f/TOTAL_GAMES).to_s + "\t" + (away_stat.to_f/TOTAL_GAMES).to_s).yellow
  end

  def print_total_outs
    home_total_outs = (@records["Home Strikeouts"]+@records["Home Catches"]+@records["Home Throwouts"]+@records["Home Double Plays"]*2).to_s
    away_total_outs = (@records["Away Strikeouts"]+@records["Away Catches"]+@records["Away Throwouts"]+@records["Away Double Plays"]*2).to_s
    print_team_stats("Total Outs", home_total_outs, away_total_outs)
  end

  def print_extra_base_hits
    home_extra_base_hits = (@records["Home Doubles"]+@records["Home Triples"]+@records["Home Homeruns"]+@records["Home Grandslams"]).to_s
    away_extra_base_hits = (@records["Away Doubles"]+@records["Away Triples"]+@records["Away Homeruns"]+@records["Away Grandslams"]).to_s
    print_team_stats("Extra Base Hits", home_extra_base_hits, away_extra_base_hits)
  end

  def print_stats
    puts ("\t\t"+HOM+"\t"+AWA+"\t"+HOM+"\t"+AWA).yellow
    print_team_stats("Wins\t", @records["Home Wins"].to_s, @records["Away Wins"].to_s)
    puts "\n"
    print_team_stats("Groundballs", @records["Home Groundballs"].to_s, @records["Away Groundballs"].to_s)
    print_team_stats("Flyballs", @records["Home Flyballs"].to_s, @records["Away Flyballs"].to_s)
    home_hits = (@records["Home Groundballs"]+@records["Home Flyballs"]).to_s
    away_hits = (@records["Away Groundballs"]+@records["Away Flyballs"]).to_s
    print_team_stats("Hits\t", home_hits, away_hits)
    puts "\n"
    print_team_stats("Foul Balls", @records["Home Foul Balls"].to_s, @records["Away Foul Balls"].to_s)
    print_team_stats("Walked\t", @records["Home Walked"].to_s, @records["Away Walked"].to_s)
    print_team_stats("Singles\t", @records["Home Singles"].to_s, @records["Away Singles"].to_s)
    print_team_stats("Doubles\t", @records["Home Doubles"].to_s, @records["Away Doubles"].to_s)
    print_team_stats("Triples\t", @records["Home Triples"].to_s, @records["Away Triples"].to_s)
    print_team_stats("Homeruns", @records["Home Homeruns"].to_s, @records["Away Homeruns"].to_s)
    print_team_stats("Grandslams", @records["Home Grandslams"].to_s, @records["Away Grandslams"].to_s)
    print_extra_base_hits
    print_team_stats("Runs\t", @records["Home Runs"].to_s, @records["Away Runs"].to_s)
    print_team_stats("Runs Left", @records["Home RLOB"].to_s, @records["Away RLOB"].to_s)
    puts "\n"
    print_team_stats("Pitches\t", @records["Home Pitches"].to_s, @records["Away Pitches"].to_s)
    print_team_stats("Strikes\t", @records["Home Strikes"].to_s, @records["Away Strikes"].to_s)
    print_team_stats("Balls\t", @records["Home Balls"].to_s, @records["Away Balls"].to_s)
    print_team_stats("Walks\t", @records["Home Walks"].to_s, @records["Away Walks"].to_s)
    print_team_stats("Strikeouts", @records["Home Strikeouts"].to_s, @records["Away Strikeouts"].to_s)
    puts "\n"
    print_team_stats("Catches\t", @records["Home Catches"].to_s, @records["Away Catches"].to_s)
    print_team_stats("Throwouts", @records["Home Throwouts"].to_s, @records["Away Throwouts"].to_s)
    print_team_stats("Double Plays", @records["Home Double Plays"].to_s, @records["Away Double Plays"].to_s)
    puts "\n"
    print_total_outs
  end

  @home_score = 0
  @away_score = 0

  @out_count = 0
  @ball_count = 0
  @strike_count = 0

  @home_pitches_thrown = 0
  @away_pitches_thrown = 0

  @home_pitching_stamina = HOME_PITCHING_STAMINA
  @away_pitching_stamina = AWAY_PITCHING_STAMINA

  @away_is_batting = true

  @man_on_first_base = false
  @man_on_second_base = false
  @man_on_third_base = false

  @current_inning = 1

  @home_wins = 0
  @away_wins = 0
  @ties = 0
  @longest = 0
  @mercy_rule = 0
  @blowout = 0
  @total_innings = 0

  @records = Hash.new
  @records["Home Wins"] = 0
  @records["Home Groundballs"] = 0
  @records["Home Flyballs"] = 0
  @records["Home Foul Balls"] = 0
  @records["Home Walked"] = 0
  @records["Home Singles"] = 0
  @records["Home Doubles"] = 0
  @records["Home Triples"] = 0
  @records["Home Homeruns"] = 0
  @records["Home Grandslams"] = 0
  @records["Home Runs"] = 0
  @records["Home Pitches"] = 0
  @records["Home Strikes"] = 0
  @records["Home Balls"] = 0
  @records["Home Walks"] = 0
  @records["Home Strikeouts"] = 0
  @records["Home Catches"] = 0
  @records["Home Throwouts"] = 0
  @records["Home Double Plays"] = 0
  @records["Home RLOB"] = 0

  @records["Away Wins"] = 0
  @records["Away Groundballs"] = 0
  @records["Away Flyballs"] = 0
  @records["Away Foul Balls"] = 0
  @records["Away Walked"] = 0
  @records["Away Singles"] = 0
  @records["Away Doubles"] = 0
  @records["Away Triples"] = 0
  @records["Away Homeruns"] = 0
  @records["Away Grandslams"] = 0
  @records["Away Runs"] = 0
  @records["Away Pitches"] = 0
  @records["Away Strikes"] = 0
  @records["Away Balls"] = 0
  @records["Away Walks"] = 0
  @records["Away Strikeouts"] = 0
  @records["Away Catches"] = 0
  @records["Away Throwouts"] = 0
  @records["Away Double Plays"] = 0
  @records["Away RLOB"] = 0

  TOTAL_GAMES.times do
    @current_inning = 1

    if PLAY_MERCY_RULE
      while @current_inning <= MIN_INNINGS && (@home_score - @away_score).abs < MERCY_LIMIT do
        puts ("\n[----------> INNING " + @current_inning.to_s + " <----------]").light_yellow
        puts ("\n---> TOP OF " + @current_inning.to_s + " <---").light_yellow
        while @out_count < 3 do
          pitch_and_swing(@away_is_batting)
        end
        end_inning(@away_is_batting)
        puts ("\n---> BOTTOM OF " + @current_inning.to_s + " <---").light_yellow
        while @out_count < 3 do
          pitch_and_swing(@away_is_batting)
        end
        end_inning(@away_is_batting)
        @current_inning += 1
      end
    else
      while @current_inning <= MIN_INNINGS do
        puts ("\n[----------> INNING " + @current_inning.to_s + " <----------]").light_yellow
        puts ("\n---> TOP OF " + @current_inning.to_s + " <---").light_yellow
        while @out_count < 3 do
          pitch_and_swing(@away_is_batting)
        end
        end_inning(@away_is_batting)
        puts ("\n---> BOTTOM OF " + @current_inning.to_s + " <---").light_yellow
        while @out_count < 3 do
          pitch_and_swing(@away_is_batting)
        end
        end_inning(@away_is_batting)
        @current_inning += 1
      end
    end


    if @current_inning <= MIN_INNINGS+1 && (@home_score - @away_score).abs >= MERCY_LIMIT && PLAY_MERCY_RULE
      @mercy_rule += 1 if @current_inning <= 9
      puts 'MERCY CALLED' if @current_inning <= 9
      @blowout +=1 if @current_inning > 9 && (@home_score - @away_score).abs >= BLOWOUT_LIMIT
      puts 'BLOWOUT' if @current_inning > 9 && (@home_score - @away_score).abs >= BLOWOUT_LIMIT
    end
    while @home_score === @away_score do
      puts ("\n[----------> INNING " + @current_inning.to_s + " <----------]").magenta
      puts ('---> TOP OF ' + @current_inning.to_s + " <---").light_yellow
      while @out_count < 3 do
        pitch_and_swing(@away_is_batting)
      end
      end_inning(@away_is_batting)
      puts ('---> BOTTOM OF ' + @current_inning.to_s + " <---").light_yellow
      while @out_count < 3 do
        pitch_and_swing(@away_is_batting)
      end
      end_inning(@away_is_batting)
      @current_inning += 1
    end

    @longest = @current_inning-1 if @current_inning-1 > @longest
    @home_max = @home_score if @home_max < @home_score
    @away_max = @away_score if @away_max < @away_score

    declare_winner
    reset_game
  end

  puts "\n"
  puts (@home_wins.to_s + '-' + @ties.to_s + '-' + @away_wins.to_s).cyan
  home_win_perc = (@home_wins.to_f/TOTAL_GAMES).to_f.round(4)
  puts ('HOME: ' + home_win_perc.to_s).cyan
  tie_perc = ((TOTAL_GAMES-@home_wins-@away_wins).to_f/TOTAL_GAMES).to_f.round(4)
  puts ('TIES: ' + tie_perc.to_s).cyan
  away_win_perc = (@away_wins.to_f/TOTAL_GAMES).to_f.round(4)
  puts ('AWAY: ' + away_win_perc.to_s).cyan
  puts 'LONGEST GAME: ' + @longest.to_s
  puts 'AVG INNINGS: ' + (@total_innings/TOTAL_GAMES).to_s
  puts 'HOME AGG: ' + @home_aggregate.to_s
  puts 'HOME MAX: ' + @home_max.to_s
  puts 'AWAY AGG: ' + @away_aggregate.to_s
  puts 'AWAY MAX: ' + @away_max.to_s
  puts 'BIG WINS: ' + (@mercy_rule + @blowout).to_s
  puts 'MERCY RULE: ' + @mercy_rule.to_s
  puts 'BLOWOUT: ' + @blowout.to_s

  puts "\n\n\n\n\n"

  print_stats
end

def testing
  a = Player.new
  b = Player.new

  puts a

  puts b
end
