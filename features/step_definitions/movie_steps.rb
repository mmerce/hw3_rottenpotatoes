# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    @movie = Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert(page.body.index(e1) < page.body.index(e2), e1+".*"+e2+" not found")
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  first = false
  rating_list.split(",").each do |rating|
    rating = rating.strip()
    if (!first)
      And %Q{I #{uncheck}check "ratings_#{rating}"}
      first = true
    else
      When %Q{I #{uncheck}check "ratings_#{rating}"}
    end
  end

end
#  group changing
When /(all|no) ratings selected/ do |uncheck|
  ratings = Movie.all_ratings().join(",")
  if uncheck == "all"
    uncheck = ""
  else
    uncheck = "un"
  end

  When %Q{I #{uncheck}check the following ratings: #{ratings}}
end

Then /I should see (all|no) movies/ do |quantify|
  if quantify == "all"
    value = Movie.find(:all).length()
  else
    value = 0
  end
  rows = page.body.scan(/<tr>/)
  assert((rows.length() -1)  == value, "rows" + rows.to_s() + ", value" + value.to_s())
end

