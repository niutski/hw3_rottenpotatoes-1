# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    m = Movie.new(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
    m.save
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp_string = ".*#{e1}.*#{e2}.*"
  regexp = Regexp.new(regexp_string, Regexp::MULTILINE)
  matches = regexp.match page.body
  assert matches, "#{e1} did not occur before #{e2}"
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #  iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  rating_list.split(",").each do |rating| 
    steps %Q{
	When I #{uncheck}check "ratings_#{rating.strip}"
    } 
  end
end
Then /I should see all of the movies/ do
   movie_count = Movie.all.size
   rows = all("#movies tbody tr").count.to_i
   assert rows == movie_count, "Movie count does not match"
end

Then /I should not see any of the movies/ do
   assert all("#movies tbody tr").count == 0, "No movies should be visible"
end
