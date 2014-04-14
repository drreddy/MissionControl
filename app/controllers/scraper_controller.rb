class ScraperController < ApplicationController
  def index
  
  end

  def esa
  	require 'nokogiri'
  	require 'open-uri'
  	proxy = ""
    url = "http://www.esa.int/ESA/Our_Missions"
    begin
        doc0 = Nokogiri::HTML(open(url,:proxy => proxy))
	rescue
		
	end

	@data = Array.new()
	@imgsrc = Array.new()
	@resp = Array.new()
	if (doc0)
		a = doc0.css('.mis_txt a')
		a.each do |var|
			
			check = var.attribute('href').to_s.split('//')
			if (check[0] == "http:")
				link = var.attribute('href').to_s
			else
				link = "http://www.esa.int" + var.attribute('href').to_s
			end
			if(var.children.count == 4)
				@data.push(var.children.first.text + " || " + var.children.first.next_sibling.text + " || " + var.children.last.text + " || " + link)
			else

				@data.push(var.children.first.text + " || " + "Launched: "+var.children.last.text.gsub(/[^0-9]/, ' ').squish.split(' ').join(', ') + " || " + var.children.last.text.split(":").last.split(', ').last.gsub(/\d+/, "").squeeze(" ").strip + " || " + link)
			end
		end

		img = doc0.css('.mis_img img')
		img.each do |var|
			@imgsrc.push("http://www.esa.int" + var.attribute('src').to_s)
		end

		i=0

		# rails g model Mission name:text desc:text date:text img:text width:text height:text more:text agency:text

		@data.each do |data|
			info = data.split(' || ')
			@temp = Hash.new
			@temp[:name] = info[0]
			@temp[:launch_dates] = info[1].gsub(/[^0-9]/, ' ').squish.split(' ')
			@temp[:desc] = info[2]
			@temp[:img] = @imgsrc[i]
			@temp[:width] = '200'
			@temp[:height] = '200'
			@temp[:more_info] = info[3]
			@temp[:agency] = "ESA"
			
			@resp.push(@temp)
			i += 1
		end

		@resp_json = @resp.to_json.html_safe
		
	else

	end

  end

  def jsa
  	require 'nokogiri'
  	require 'open-uri'
  	proxy = ""
  	past_url = "http://www.jaxa.jp/projects/past_project/sat_e.html"
  	record_url = "http://www.jaxa.jp/projects/result_e.html"

  	begin
        doc = Nokogiri::HTML(open(past_url,:proxy => proxy))
        doc1 = Nokogiri::HTML(open(record_url,:proxy => proxy))
	rescue
		#.kakopro a #content img
	end

	@img_url = Array.new()
	@desc = Array.new()
	@resp = Array.new()

	i = 0

	@count = 0

	if (doc)
		@past_resp_name = doc.css('td:nth-child(1)')
		@past_resp_date = doc.css('td:nth-child(2)').map(&:text)
		@past_resp_desc = doc.css('td:nth-child(3)').map(&:text)

		@past_resp_name.each do | record |

			@temp = Hash.new
			@temp[:name] = record.children.first.text.squish

			if (record.children.count == 1)

				link = record.children.first.attribute('href').to_s

				check = link.split("://")

				if (check[0] == "http")

					begin
				        doc3 = Nokogiri::HTML(open(link,:proxy => proxy))
					rescue
						#.kakopro a #content img
					end

					if(doc3)

						parts = link.split('http://www.isas.jaxa.jp/')[1].split('/')
						parts.pop
						sanitized_link = parts.join('/')
						@temp[:img] = 'http://www.isas.jaxa.jp/' + sanitized_link + '/' + doc3.css(".pct1c img").attribute('src').to_s
						@temp[:width] = doc3.css(".pct1c img").attribute('width').to_s
						@temp[:height] = doc3.css(".pct1c img").attribute('height').to_s
						@temp[:desc] = doc3.at_xpath("//*[text()='Objectives']/following-sibling::*[1]").text.squish

					end

				else

					link = "http://www.jaxa.jp"+link

					begin
				        doc4 = Nokogiri::HTML(open(link,:proxy => proxy))
					rescue
						#.kakopro a #content img
					end

					if(doc4)

						if(doc4.at_css('.naiyou387 .float-right img'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc4.css(".naiyou387 .float-right img").attribute('src').to_s
							@temp[:width] = doc4.css(".naiyou387 .float-right img").attribute('width').to_s
							@temp[:height] = doc4.css(".naiyou387 .float-right img").attribute('height').to_s
							@temp[:desc] = doc4.css('.naiyou387 .float-right').first.next_element.text.squish

						elsif (doc4.at_css('.naiyou387 .float-left img'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc4.css(".naiyou387 .float-left img").attribute('src').to_s
							@temp[:width] = doc4.css(".naiyou387 .float-left img").attribute('width').to_s
							@temp[:height] = doc4.css(".naiyou387 .float-left img").attribute('height').to_s
							@temp[:desc] = doc4.css('.naiyou387 .float-left').first.next_element.text.squish

						elsif (doc4.at_css('.naiyou387 .image-center img'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc4.css(".naiyou387 .image-center img").attribute('src').to_s
							@temp[:width] = doc4.css(".naiyou387 .image-center img").attribute('width').to_s
							@temp[:height] = doc4.css(".naiyou387 .image-center img").attribute('height').to_s
							@temp[:desc] = doc4.css('.naiyou387 .image-center').first.next_element.text.squish

						elsif (doc4.at_css('.naiyou387 .text-top'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc4.css('.naiyou387 .text-top').first.previous_element.attribute('src').to_s
							@temp[:width] = doc4.css(".naiyou387 .text-top").first.previous_element.attribute('width').to_s
							@temp[:height] = doc4.css(".naiyou387 .text-top").first.previous_element.attribute('height').to_s
							@temp[:desc] = doc4.css('.naiyou387 .text-top').first.text.squish

						elsif(doc4.at_css('.naiyou387 img.float-right'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc4.css(".naiyou387 img.float-right").attribute('src').to_s
							@temp[:width] = doc4.css(".naiyou387 img.float-right").attribute('width').to_s
							@temp[:height] = doc4.css(".naiyou387 img.float-right").attribute('height').to_s
							@temp[:desc] = doc4.css('.naiyou387 .float-right').first.next_element.text.squish

						else
							@temp[:img] = 'nill'
							@temp[:width] = 'nill'
							@temp[:height] = 'nill'
							@temp[:desc] = @past_resp_desc[i].squish
							@count+=1
							
						end

					end
					
				end

				@temp[:more_info] = link

			else
				@temp[:img] = 'nill'
				@temp[:width] = 'nill'
				@temp[:height] = 'nill'
				@temp[:desc] = @past_resp_desc[i].squish
				@temp[:more_info] = 'nill'
			end

			@temp[:launch_dates] = Array.new()
			@temp[:launch_dates].push(@past_resp_date[i])
			@temp[:agency] = "JAXA"
			
			@resp.push(@temp)

			i+=1

		end

		#@resp_json = @resp.to_json.html_safe
		i = 0

		@record_resp_date = doc1.css('td:nth-child(1)').map(&:text)
		@record_resp_name = doc1.css('td:nth-child(3)')
		@record_resp_name.each do | record |
		
			if (record.children.count == 1)

				@temp = Hash.new
				@temp[:name] = record.children.first.text.squish
				@temp[:desc] = record.children.first.text.squish 
				if (record.children.first.key?('href'))

					link = "http://www.jaxa.jp" + record.children.first.attribute('href').to_s

					begin
				        doc5 = Nokogiri::HTML(open(link,:proxy => proxy))
					rescue
						#.kakopro a #content img
						doc5 = Nokogiri::HTML(open('http://www.jaxa.jp/projects/rockets/htv/index_e.html',:proxy => 'http://10.3.100.212:8080'))
					end

					if(doc5)
						if(doc5.at_css('.naiyou387 p'))

							parts = link.split('http://www.jaxa.jp/')[1].split('/')
							parts.pop
							sanitized_link = parts.join('/')
							@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc5.at_css('.image-center img').attribute('src').to_s
							@temp[:width] = doc5.at_css('.image-center img').attribute('width').to_s
							@temp[:height] = doc5.at_css('.image-center img').attribute('height').to_s
						else

							@temp[:img] = 'nill'
							@temp[:width] = 'nill'
							@temp[:height] = 'nill'

						end

					end

					@temp[:more_info] = link
				else

					@temp[:img] = 'nill'
					@temp[:width] = 'nill'
					@temp[:height] = 'nill'
					@temp[:more_info] = 'nill'

				end

				@temp[:launch_dates] = Array.new()
				@temp[:launch_dates].push(@record_resp_date[i])
				@temp[:agency] = "JAXA"

				@resp.push(@temp)

			else

				record.children.each do | sub_child |

					@temp = Hash.new
					@temp[:name] = sub_child.text.squish
					@temp[:desc] = sub_child.text.squish
					if (sub_child.key?('href'))

						link = "http://www.jaxa.jp" + sub_child.attribute('href').to_s

						begin
					        doc5 = Nokogiri::HTML(open(link,:proxy => proxy))
						rescue
							#.kakopro a #content img
						end

						if(doc5)
							if(doc5.at_css('.naiyou387'))

								parts = link.split('http://www.jaxa.jp/')[1].split('/')
								parts.pop
								sanitized_link = parts.join('/')
								@temp[:img] = 'http://www.jaxa.jp/' + sanitized_link + '/' + doc5.at_css('.image-center img').attribute('src').to_s
								@temp[:width] = doc5.at_css('.image-center img').attribute('width').to_s
								@temp[:height] = doc5.at_css('.image-center img').attribute('height').to_s

							else

								@temp[:img] = 'nill'
								@temp[:width] = 'nill'
								@temp[:height] = 'nill'

							end

						end

						@temp[:more_info] = link
					else

						@temp[:img] = 'nill'
						@temp[:width] = 'nill'
						@temp[:height] = 'nill'
						@temp[:more_info] = 'nill'

					end

					@temp[:launch_dates] = Array.new()
					@temp[:launch_dates].push(@record_resp_date[i])
					@temp[:agency] = "JAXA"

					@resp.push(@temp)

				end			

			end

			i+=1
			
		end

		@resp_json = @resp.to_json.html_safe
	else

	end



  end

  def test
  end
end