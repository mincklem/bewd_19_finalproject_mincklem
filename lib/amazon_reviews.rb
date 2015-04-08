#no amazon reviews at the moment, this is for future-state

amz_count = []

class Amazon
	def get_amazon_review(isbn)
		puts "amazon function running"
		puts "#{isbn}"
		time = Time.now.utc.iso8601.chomp
		puts time
		1.times do | page_num |
			amz_API = "http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemLookup&ResponseGroup=Reviews
			  &IdType=ISBN&ItemId=#{isbn}&AssociateTag=5890-8964-3068&AWSAccessKeyId=AKIAIZQPE2FGSZWVC53Q&Timestamp=#{time}&Signature=Htn3p9CQ/sHUK0ew3pr0EHhUMWO/S/VNccN+JikX"
			amz_raw_output = RestClient.get(amz_API)
			amz_json_output = JSON.load(amz_raw_output)
			puts amz_json_output
		end
	end
end


# aws_secret = 'AKIAIZQPE2FGSZWVC53Q' # aws provides this
# query_string = 'Operation=CreateJob&Manifest=...' # this is for your api call

# hmac = HMAC::SHA256.new(aws_secret)
# hmac.update(query_string)
# signature = Base64.encode64(hmac.digest).chomp

# def getSignatureKey key, dateStamp, regionName, serviceName
#     kDate    = OpenSSL::HMAC.digest('sha256', "AWS4" + key, dateStamp)
#     kRegion  = OpenSSL::HMAC.digest('sha256', kDate, regionName)
#     kService = OpenSSL::HMAC.digest('sha256', kRegion, serviceName)
#     kSigning = OpenSSL::HMAC.digest('sha256', kService, "aws4_request")

#     kSigning
# end