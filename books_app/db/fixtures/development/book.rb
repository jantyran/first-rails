(1..50).each do |i|	
	Book.seed do |s|
		s.title = "seed#{i}"
		s.memo = "memo#{i}"
		s.author = "author#{i}"
		s.picture = ""
	end
end