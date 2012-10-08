class GetHars
	def initialize(db)
		@db = db
	end

	def choseColl(coll_name)
		@coll = @db[coll_name]
	end	
	def getAll
		@coll.find.each{|e| yield e}
	end

	def getSome(n)
		@coll.find.limit(n).each {|e| yield e}
	end
end