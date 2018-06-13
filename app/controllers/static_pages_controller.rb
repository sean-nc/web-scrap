class StaticPagesController < ApplicationController
  require 'httparty'
  require 'nokogiri'

  def home
    @url = params[:url]

    if @url.empty?
      @url = nil
    else
      begin
        page = HTTParty.get(@url)

        if page.empty?
          flash.now[:alert] = "Please enter a valid URL"
          render 'home'
        else
          nokogiri_html = Nokogiri::HTML(page)
          @name = nokogiri_html.css('.player-jumbotron-vitals__name-num').text.split(" | ")[0]
          @number = nokogiri_html.css('.player-jumbotron-vitals__name-num').text.split(" | ")[1]
          @position = nokogiri_html.css('.player-jumbotron-vitals--attr')[0].text
          @height = nokogiri_html.css('.player-jumbotron-vitals--attr')[1].text
          @weight = nokogiri_html.css('.player-jumbotron-vitals--attr')[2].text
          @age = nokogiri_html.css('.player-jumbotron-vitals--attr')[3].text.split(' ')[1..-1].join(' ')
          @team = nokogiri_html.css('.player-jumbotron-vitals--attr')[4].text
          @image = nokogiri_html.css('.player-jumbotron-cover div').map{ |n| n['style'][/url\((.+)\)/, 1] }[0].gsub!("'", "")
          @headshot = nokogiri_html.css('.player-jumbotron-vitals__headshot img').attr('src').to_s
          @birth_date = nokogiri_html.css('li.player-bio__item')[1].text.split(': ')[1]
          @birth_place = nokogiri_html.css('li.player-bio__item')[2].children[2]
          @shoots = nokogiri_html.css('li.player-bio__item')[3].text.split(': ')[1]
        end

      rescue HTTParty::Error
        flash.now[:alert] = "Not a valid URL"
      rescue StandardError
        flash.now[:alert] = "Not a valid URL"
      end
    end
  end
end
