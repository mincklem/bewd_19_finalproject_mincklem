# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Adding a Whole bunch of reviews"
Review.create [
  { isbn: 1234567890, 
    title: "The Shawshank Redemption",
    review_text: "Morgan Freeman in Jail",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "The Godfather",
    review_text: "Hard core Gangster activity",
    star_rating: 3
  },
  { isbn: 1234567890, 
    title: "The Godfather: Part II",
    review_text: "More Gangsters, aw yea",
    star_rating: 4
  },
  { isbn: 1234567890, 
    title: "Pulp Fiction",
    review_text: "Samuel Jackson screams a LOT! Say What again!",
    star_rating: 2
  },
  { isbn: 1234567890, 
    title: "The Good, the Bad and the Ugly",
    review_text: "Cowboys will be cowboys",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "12 Angry Men",
    review_text: "Really old movie about a court case. They have anger issues",
    star_rating: 5
  },
  { isbn: 1234567890, 
    title: "The Dark Knight",
    review_text: "Batman (not a super hero), battles the joker for who can have the most not normal voice ever",
    star_rating: 4
  },
  { isbn: 1234567890, 
    title: "Schindler's List",
    review_text: "It's about the Holocaust I think",
    star_rating: 3
  },
  { isbn: 1234567890, 
    title: "The Lord of the Rings: The Return of the King",
    review_text: "Something to do with Hobbits",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "Fight Club",
    review_text: "This is your life... Apparently it's really easy to make explosives",
    star_rating: 3
  },
  { isbn: 1234567890, 
    title: "Star Wars: Episode V - The Empire Strikes Back",
    review_text: "The best Star Wars EVER",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "The Lord of the Rings: The Fellowship of the Ring",
    review_text: "More Hobbits",
    star_rating: 5
  },
  { isbn: 1234567890, 
    title: "One Flew Over the Cuckoo's Nest",
    review_text: "Crazy guy does crazy stuff",
    star_rating: 4
  },
  { isbn: 1234567890, 
    title: "Inception",
    review_text: "Dream in a dream, in a nap, in a dozing off in class",
    star_rating: 5
  },
  { isbn: 1234567890, 
    title: "Goodfellas",
    review_text: "I think Joe Pesci is in this one",
    star_rating: 6
  },
  { isbn: 1234567890, 
    title: "Star Wars",
    review_text: "Let the Wookie win",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "Seven Samurai",
    review_text: "One of the best films ever made... according to Wikipedia",
    star_rating: 3
  },
  { isbn: 1234567890, 
    title: "Forrest Gump",
    review_text: "Life is like a box of chocolates. It will give you diabetes",
    star_rating: 4
  },
  { isbn: 1234567890, 
    title: "The Matrix",
    review_text: "Playing videogames can teach you kung-fu",
    star_rating: 1
  },
  { isbn: 1234567890, 
    title: "The Lord of the Rings: The Two Towers",
    review_text: "Again with the Hobbits and their jewelry obsession",
    star_rating: 2
  }]