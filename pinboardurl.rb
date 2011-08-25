#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'nokogiri'
require 'open-uri'
	#sender found at ARGV[0]
	#message found at STDIN

	#Pull out url
	message = STDIN.read.strip
	foundurl = URI.extract(message)[0]
	

  if foundurl

    #Get page title
    page = Nokogiri::HTML(open(foundurl))
    title = page.css('title')[0].content
      
    
	  #Post to pinboard    
    uri = URI.parse("https://api.pinboard.in/v1/posts/add")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    querystring = "?"
    query = {'url' => foundurl,
                    'description' => title,
                    "tags" => 'im ' + ARGV[0].gsub(/\s/, "")
                    }.each_pair do |key, value|
                      
       querystring += key + "=" + CGI.escape(value) + "&"              
    end
    

    request = Net::HTTP::Get.new(uri.request_uri + querystring)
    request.basic_auth("pinboarduser","pinboardpass")
                   
    response = http.request(request)
  end