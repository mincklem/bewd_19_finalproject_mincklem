module WordCloud
	@count_limit
	@cloud_excludes
	@user_excludes
	class WordCount
		@@all_reviews_text = []
		attr_accessor :user_cloud_prefs
		
		def initialize(user_cloud_prefs)
			@user_cloud_prefs = user_cloud_prefs
		end

		def get_reviews_by_stars
			@star_array = @user_cloud_prefs[0][:stars]
			#get user minimum term frequency
			@count_limit = @user_cloud_prefs[0][:count].to_i
			#get user exclusion terms
			@user_excludes = @user_cloud_prefs[0][:user_excludes].downcase.split(' ')
			@user_excludes.collect{|x| x.strip}
			# @star_array.pop
			if @star_array.nil?
			reviews = Review.all
			else
			@star_array.map!{ |element| element.gsub(/sb/, '') }
			reviews = Review.where(:star_rating => @star_array) 
			end
			# get star reviews from database by rating

			#get review text from each and add to variable
			reviews.each do |review|
				@@all_reviews_text.push(review.review_text)
			end
			#convert to string, strip quotation marks
			puts @@all_reviews_text
			puts @@all_reviews_text.length
			passing_text = @@all_reviews_text.to_s.tr('"','')
			count_words(passing_text)
		end

		def count_words(passing_text)
			#count the words
			text = passing_text.downcase.scan(/\s*("([^"]+)"|\w+)\s*/).map { |match| match[1].nil? ? match[0] : match[1] }
			#filter out common 'stopwords'
			f_text = text.delete_if{|x| $stop_words.split(" ").include?(x)}.join(' ')
			counts = Hash.new 0
			f_text.split(" ").each do |word|
  				counts[word] += 1
			end
			sorted_counts = counts.sort_by(&:last)
			hash_counts = Hash[*sorted_counts.flatten]
			# if defined?(@count_limit)
			# 	@count_limit == 5
			# end
			#remove 1 letter words (key.length) that appear less than a certain number of times (value) 
			hash_counts.delete_if {|key, value| key.length <= 1 || value < @count_limit}
			# key.scan(/\[[0-9]+\]/) { |match| match }

			#remove user exclusion words 
			@user_excludes.each do |word|
				hash_counts.delete_if {|key, value| key == word }
				puts "deleting #{word}"
			end
			@@all_reviews_text.clear
			hash_counts
		end
	end

	class StopWords
		$stop_words = 
			"a
			ve
			ll
			about
			above
			after
			re
			again
			against
			all
			am
			an
			and
			any
			are
			aren't
			as
			at
			be
			because
			been
			before
			being
			below
			between
			both
			but
			by
			can't
			cannot
			could
			couldn't
			did
			didn't
			do
			does
			doesn't
			doing
			don't
			down
			during
			each
			few
			for
			from
			further
			had
			hadn't
			has
			hasn't
			have
			haven't
			having
			he
			he'd
			he'll
			he's
			her
			here
			here's
			hers
			herself
			him
			himself
			his
			how
			how's
			i
			i'd
			i'll
			i'm
			i've
			if
			in
			into
			is
			isn't
			it
			it's
			its
			itself
			let's
			me
			more
			most
			mustn't
			my
			myself
			no
			nor
			not
			of
			off
			on
			once
			only
			or
			other
			ought
			our
			ours	ourselves
			out
			over
			own
			same
			shan't
			she
			she'd
			she'll
			she's
			should
			shouldn't
			so
			some
			such
			than
			that
			that's
			the
			their
			theirs
			them
			themselves
			then
			there
			there's
			these
			they
			they'd
			they'll
			they're
			they've
			this
			those
			through
			to
			too
			under
			until
			up
			very
			was
			wasn't
			we
			we'd
			we'll
			we're
			we've
			were
			weren't
			what
			what's
			when
			when's
			where
			where's
			which
			while
			who
			who's
			whom
			why
			why's
			with
			won't
			would
			wouldn't
			you
			you'd
			you'll
			you're
			you've
			your
			yours
			yourself
			yourselves"
	end

end