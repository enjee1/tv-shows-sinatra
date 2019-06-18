require "spec_helper"

feature "user views list of TV shows" do
  # As a TV fanatic
  # I want to view a list of TV shows
  # So I can find new shows to watch
  #
  # Acceptance Criteria:
  # * I can see the names and networks of all TV shows

  scenario "view list of TV shows" do
    # First create some sample TV shows
    game_of_thrones = TelevisionShow.create!({
        title: "Game of Thrones", network: "HBO",
        starting_year: 2011, genre: "Fantasy"
      })

    married_with_children = TelevisionShow.create!({
        title: "Married... with Children", network: "Fox",
        starting_year: 1987, ending_year: 1997,
        genre: "Comedy"
      })

    # The user visits the index page
    visit "/television_shows"

    # And should see both TV shows listed (just the title and network)
    expect(page).to have_content("Game of Thrones (HBO)")
    expect(page).to have_content("Married... with Children (Fox)")
  end

  # As a TV fanatic
  # I want to view the details for a TV show
  # So I can find learn more about it

  # Acceptance Criteria:
  # * I can see the title, network, start and end year, genre, and synopsis
  #   for a show.
  # * If the end year is not provided it should indicate that the show is still
  #   running.

  scenario "view details for a TV show" do
    visit "/television_shows/new"
    friends = TelevisionShow.create!({
        title: "Friends", network: "NBC", starting_year: 1994,
        ending_year: 2004, genre: "Comedy"
      })

    visit "/television_shows"
    expect(page).to have_content("Friends (NBC)")

    visit "/television_shows/#{friends.id}"
    expect(page).to have_content("Friends")
    expect(page).to have_content("NBC")
    expect(page).to have_content(1994)
    expect(page).to have_content(2004)

  end
  scenario "view details for a TV show with missing information" do
    visit "/television_shows/new"
    mash = TelevisionShow.create!({
        title: "M*A*S*H", network: "CBS", starting_year: 1972
      })

    visit "/television_shows"
    expect(page).to have_content("M*A*S*H (CBS)")

    visit "/television_shows/#{mash.id}"
    expect(page).to have_content("M*A*S*H")
    expect(page).to have_content("CBS")
    expect(page).to have_content(1972)
    expect(page).to have_content("Show is still running.")

  end
end
