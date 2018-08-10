NAMES = ["Son",
  "Arlie",
  "Diego",
  "Jayson",
  "Rogelio",
  "Claude",
  "Claudio",
  "Bradly",
  "Vern",
  "Daniel",
  "Werner",
  "Neville",
  "Eldon",
  "Booker",
  "Jarrod",
  "Sergio",
  "Juan",
  "Dillon",
  "Earle",
  "Boyce",
  "Jewel",
  "Francis",
  "Dwain",
  "Clifton",
  "Jeffry",
  "Man",
  "Hilario",
  "Emanuel",
  "Rayford",
  "Horace",
  "Ernie",
  "Olen",
  "Sammie",
  "Elvis",
  "Joesph",
  "Neil",
  "Harrison",
  "Manual",
  "Emmitt",
  "Brooks",
  "Jarred",
  "Andre",
  "Milford",
  "Sam",
  "Wilmer",
  "Kraig",
  "Freddy",
  "Jed",
  "Jessie",
  "William",
  "Anderson",
  "Edward",
  "Antione",
  "Basil",
  "Frank",
  "Erik",
  "Russel",
  "Ronnie",
  "Brooks",
  "Dalton",
  "David",
  "Julio",
  "Luther",
  "Rickey",
  "Marion",
  "Warren",
  "Jefferson",
  "Oren",
  "Randolph",
  "Major",
  "Oliver",
  "Jed",
  "Cedrick",
  "Rick",
  "Berry",
  "Bob",
  "Leslie",
  "Marcelo",
  "Brian",
  "Sergio",
  "Alberto",
  "Aron",
  "Mitchell",
  "Granville",
  "Jarred",
  "Cruz",
  "Dwight",
  "Darell",
  "Russell",
  "Chance",
  "Wade",
  "Man",
  "Kraig",
  "Irvin",
  "Teddy",
  "Lucius",
  "Albert",
  "Neil",
  "Jerry",
  "Anton",
  "Rodrick",
  "Miles",
  "Zachary",
  "Geraldo",
  "Bryant",
  "Rigoberto",
  "Silas",
  "Irwin",
  "Curtis",
  "Dee",
  "Von",
  "Jacques",
  "Dean",
  "Antonia",
  "Hilton",
  "Owen",
  "Jc",
  "Elliot",
  "Shelby",
  "Bret",
  "Donald",
  "Jonathon",
  "Bernie",
  "Emile",
  "Carroll",
  "Myles",
  "Hollis",
  "Dwayne",
  "Riley",
  "Dannie",
  "Jospeh",
  "Laurence",
  "Barton",
  "Ike",
  "Delmer",
  "Chi",
  "Horace",
  "Wayne",
  "Valentine",
  "Benjamin",
  "Lino",
  "Branden",
  "Lawrence",
  "Mickey",
  "Garry",
  "Shayne",
  "Stephan",
  "Freddie",
  "Randal",
  "Titus"]

class Player
  attr_reader :name
  attr_reader :birth_day
  attr_reader :birth_month
  attr_reader :birth_year

  def initialize
    @name = NAMES.sample
    time_now = Time.now
    @birth_year = time_now.year - 18 - rand(20)
    @birth_month = 1 + rand(12)
    case @birth_month
    when 1, 3, 5, 7, 8, 10, 12
      @birth_day = 1 + rand(31)
    when 4, 6, 9, 11
      @birth_day = 1 + rand(30)
    else
      @birth_day = 1 + rand(28)
    end
    @birth_day = 18 + rand(18)
    @attributes = Hash.new

    # GENERAL ATTRIBUTES
    @attributes["speed"] = 0
    @attributes["composure"] = 0


    # FIELDING ATTRIBUTES
    @attributes["double play base"] = 0
    @attributes["double play mod"] = 0
    @attributes["fly fielding base"] = 0
    @attributes["fly fielding mod"] = 0
    @attributes["ground fielding base"] = 0
    @attributes["ground fielding mod"] = 0

    # PITCHING ATTRIBUTES
    @attributes["velocity pitching base"] = 0
    @attributes["velocity pitching mod"] = 0
    @attributes["movement pitching base"] = 0
    @attributes["movement pitching mod"] = 0
    @attributes["velocity ratio"] = 0
    @attributes["movement ratio"] = 0
    @attributes["pitching stamina"] = 0
    @attributes["strike ratio"] = 0
    @attributes["ball ratio"] = 0

    # BATTING ATTRIBUTES
    @attributes["batting base"] = 0
    @attributes["batting mod"] = 0
    @attributes["groundball ratio"] = 0
    @attributes["flyball ratio"] = 0

    @attributes["single ratio"] = 0
    @attributes["double ratio"] = 0
    @attributes["triple ratio"] = 0
    @attributes["homerun ratio"] = 0
  end

  def to_s
    temp = @name
    temp += "\t" if @name.length >= 8
    temp += "\t\t" if @name.length < 8
    temp += @birth_month.to_s +
      "/" +
      @birth_day.to_s +
      "/" +
      @birth_year.to_s +
      "\t"

    if @birth_month > Time.now.month
      temp += (Time.now.year-1-@birth_year).to_s + " years old"
    elsif @birth_month === Time.now.month
      if @birth_day > Time.now.day
        temp += (Time.now.year-1-@birth_year).to_s + " years old"
      else
        temp += (Time.now.year-@birth_year).to_s + " years old"
      end
    else
      temp += (Time.now.year-@birth_year).to_s + " years old"
    end
  end


end
