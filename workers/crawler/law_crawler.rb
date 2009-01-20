# Copyright (C) 2008,2009 Róbert Viðar Bjarnason
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'timeout'

RAILS_ENV='production'

require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"

require File.dirname(__FILE__) + '/../../app/models/document_element.rb'
require File.dirname(__FILE__) + '/../../app/models/document.rb'
require File.dirname(__FILE__) + '/../../app/models/case.rb'
require File.dirname(__FILE__) + '/../../app/models/case_document.rb'
require File.dirname(__FILE__) + '/../../app/models/case_discussion.rb'

class AlthingiDocumentElement < DocumentElement
  TYPE_HEADER_MAIN = 1
  TYPE_HEADER_CHAPTER= 2
  TYPE_HEADER_MAIN_ARTICLE = 3
  TYPE_HEADER_TEMPORARY_ARTICLE = 4
  TYPE_HEADER_ESSAY = 5
  TYPE_HEADER_COMMENTS_MAIN = 6
  TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS = 7
  TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES = 8
  TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE = 9
  TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT = 10
  TYPE_CHAPTER = 11
  TYPE_MAIN_ARTICLE = 12
  TYPE_TEMPORARY_ARTICLE = 13
  TYPE_COMMENTS_ABOUT_CHAPTERS = 14
  TYPE_COMMENTS_ABOUT_MAIN_ARTICLES = 15
  TYPE_COMMENTS_ABOUT_TEMPORARY_ARTICLES = 16
  TYPE_COMMENTS_ABOUT_WHOLE_DOCUMENT = 17
  TYPE_HEADER_MAIN_CONTENT = 18
  TYPE_ESSAY_MAIN_CONTENT = 19
  TYPE_HEADER_REPORT_ABOUT_LAW = 20
  TYPE_REPORT_ABOUT_LAW = 21
  
  def parent
    DocumentElement.find(self.parent_id) if self.parent_id
  end
  
  def content_type_s
    case self.content_type
      when 1 then "TYPE_HEADER_MAIN"
      when 2 then "TYPE_HEADER_CHAPTER"
      when 3 then "TYPE_HEADER_MAIN_ARTICLE"
      when 4 then "TYPE_HEADER_TEMPORARY_ARTICLE"
      when 5 then "TYPE_HEADER_ESSAY"
      when 6 then "TYPE_HEADER_COMMENTS_MAIN"
      when 7 then "TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS"
      when 8 then "TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES"
      when 9 then "TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE"
      when 10 then "TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT"
      when 11 then "TYPE_CHAPTER"
      when 12 then "TYPE_MAIN_ARTICLE"
      when 13 then "TYPE_TEMPORARY_ARTICLE"
      when 14 then "TYPE_COMMENTS_ABOUT_CHAPTERS"
      when 15 then "TYPE_COMMENTS_ABOUT_MAIN_ARTICLES"
      when 16 then "TYPE_COMMENTS_ABOUT_TEMPORARY_ARTICLES"
      when 17 then "TYPE_COMMENTS_ABOUT_WHOLE_DOCUMENT"
      when 18 then "TYPE_HEADER_MAIN_CONTENT"
      when 19 then "TYPE_ESSAY_MAIN_CONTENT"
      when 20 then "TYPE_HEADER_REPORT_ABOUT_LAW"
      when 21 then "TYPE_REPORT_ABOUT_LAW"
    end
  end
  
  def set_content_type_for_header    
    if is_main_header?
      self.content_type = TYPE_HEADER_MAIN
    elsif is_main_article_header?
      self.content_type = TYPE_HEADER_MAIN_ARTICLE
    elsif is_temporary_article_header?
     self.content_type = TYPE_HEADER_TEMPORARY_ARTICLE
    elsif is_chapter_header?
      self.content_type = TYPE_HEADER_CHAPTER
    elsif is_essay_header?
      self.content_type = TYPE_HEADER_ESSAY
    elsif is_comments_main_header?
      self.content_type = TYPE_HEADER_COMMENTS_MAIN
    elsif is_comments_about_chapter_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS
    elsif is_comments_about_main_article_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES
    elsif is_comments_about_temporary_article_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE
    elsif is_comments_about_whole_document_header?
      self.content_type = TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT
    elsif is_report_about_law_header?
      self.content_type = TYPE_HEADER_REPORT_ABOUT_LAW
    else
      puts "Error: Could not find header type for #{self.content}"
    end
  end
      
  def set_content_type_for_main_content
    if parent.content_type == TYPE_HEADER_MAIN_ARTICLE
      self.content_type = TYPE_MAIN_ARTICLE
    elsif parent.content_type == TYPE_HEADER_TEMPORARY_ARTICLE
      self.content_type = TYPE_TEMPORARY_ARTICLE
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_CHAPTERS
      self.content_type = TYPE_COMMENTS_ABOUT_CHAPTERS
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_MAIN_ARTICLES
      self.content_type = TYPE_COMMENTS_ABOUT_MAIN_ARTICLES
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_TEMPORARY_ARTICLE
      self.content_type = TYPE_COMMENTS_ABOUT_TEMPORARY_ARTICLES
    elsif parent.content_type == TYPE_HEADER_COMMENTS_ABOUT_WHOLE_DOCUMENT
      self.content_type = TYPE_COMMENTS_ABOUT_WHOLE_DOCUMENT
    elsif parent.content_type == TYPE_HEADER_MAIN
      self.content_type = TYPE_HEADER_MAIN_CONTENT
    elsif parent.content_type == TYPE_HEADER_ESSAY
      self.content_type = TYPE_ESSAY_MAIN_CONTENT
    elsif parent.content_type == TYPE_HEADER_REPORT_ABOUT_LAW
      self.content_type = TYPE_REPORT_ABOUT_LAW
    else
      puts "Error: Could not find content type for #{self.content} parent: #{parent.inspect}"
    end
  end

  def is_main_header?
    self.sequence_number==1
  end

  def is_chapter_header?
    content.downcase =~ /kafli/
  end

  def is_main_article_header?
    unless is_comments_about_main_article_header?      
      re1='(\\d+)'  # Integer Number 1
      re2='(\\.)' # Any Single Character 1
      re3='(\\s+)'  # White Space 1
      re4='(gr.)' # Word 1
      
      re=(re1+re2+re3+re4)
      m=Regexp.new(re,Regexp::IGNORECASE);
      if m.match(self.content.gsub(/<!-- Tab -->/," ").gsub(/&nbsp;/," "))
        self.content_number=m.match(self.content_text_only)[1];
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def is_temporary_article_header?
    unless is_comments_about_temporary_article_header?
      compare_to_content_euc("Ákvæði til bráðabirgða.")
    else
      return false
    end
  end

  def is_essay_header?
    compare_to_content_euc("greinargerð")
  end
  
  def is_comments_main_header?
    compare_to_content_euc("Athugasemdir við einstakar greinar frumvarpsins")
 end

  def is_comments_about_chapter_header?
    txt='Um I. kafla.'
    
    re1='(Um)'  # Word 1
    re2='(\\s+)'  # White Space 1
    re3='((?:[a-z][a-z0-9_]*))' # Variable Name 1
    re4='(\\.)' # Any Single Character 1
    re5='(\\s+)'  # White Space 2
    re6='(kafla)' # Word 2
    
    re=(re1+re2+re3+re4+re5+re6)
    m=Regexp.new(re,Regexp::IGNORECASE);
    if m.match(self.content)
        self.content_number=m.match(self.content)[3];  # Store the chapter number
        return true
    end
  end

  def is_comments_about_main_article_header?
    txt='Um 1. gr.'

    re1='(Um)'      # Word 1
    re2='(\\s+)'  # White Space 1
    re3='(\\d+)'  # Integer Number 1
    re4='(\\.)'     # Any Single Character 1
    re5='(\\s+)'  # White Space 2
    re6='(gr)'      # Word 2 end
    
    re=(re1+re2+re3+re4+re5+re6)
    m=Regexp.new(re,Regexp::IGNORECASE);
    if m.match(self.content.downcase.gsub(/&nbsp;/,""))
        self.content_number=m.match(self.content)[3]; # Store the article number
        return true
    else
      return false
    end    
  end

  def is_comments_about_temporary_article_header?
    compare_to_content_euc("Um ákvæði til bráðabirgða")
  end

  def is_comments_about_whole_document_header?
    compare_to_content_euc("athugasemdir við lagafrumvarp þetta")
  end
  
  def is_report_about_law_header?
    compare_to_content_euc("umsögn um frumvarp til laga um")
  end
    
  def compare_to_content_euc(string, debug=false)
    input1=string.downcase
    puts "INPUT1: #{input1}" if debug
    input2=self.content.downcase
    puts "INPUT2: #{input2}" if debug
    m=Regexp.new(input1)
    m.match(input2)
  end
end

class CaseCrawler
end

class AlthingiCrawler < CaseCrawler
  def get_law_document(case_id, case_document_id, url)
    puts "GET LAW HTML FOR: #{url}"    
  end

  def get_document(case_id, case_document_id, url)
    puts "GET HTML FOR: #{url}"
    html_doc_doc = nil
    retries = 10

    begin
      Timeout::timeout(120){
        html_doc_doc = Nokogiri::HTML(open(url))
      }
    rescue
      retries -= 1
      if retries > 0
        sleep 0.42 and retry
        puts "retry"
      else
        raise
      end
    end

    if Document.find_by_external_link(url)
      puts "Found document at: #{url}"
      return 
    end
    
    doc = Document.new
    doc.case_id = case_id
    doc.case_document_id = case_document_id
    doc.category_id = 1
    doc.document_state_id = 1
    doc.document_type_id = 1
    doc.external_link = url
    doc.voting_close_time = Time.now+1.month
    doc.original_version = true
    doc.save

    elements = []
    sequence_number = 0

    document_id = doc.id
    
    html_doc_doc.xpath('//div').each do |paragraph|
      new_parent_header_element = AlthingiDocumentElement.new
      new_parent_header_element.content = paragraph.inspect
      new_parent_header_element.content_text_only = paragraph.text
      new_parent_header_element.sequence_number = sequence_number+=1
      new_parent_header_element.document_id = document_id
      new_parent_header_element.original_version=true
      new_parent_header_element.set_content_type_for_header
      new_parent_header_element.save
      elements << new_parent_header_element
      
      next_sibling = paragraph.next_sibling
      all_content_until_next_header = ""
      all_content_until_next_header_text_only = ""
      while next_sibling and next_sibling.inspect[0..3]!="<div" and next_sibling.inspect[0..7]!="<b> <div"
        puts "SIBLING " + next_sibling.inspect
        unless next_sibling.inspect[0..3]==" Tab" or
               next_sibling.inspect[0..8]==" WP Style" or 
               next_sibling.inspect[0..7]==" WP Pair" or 
               next_sibling.inspect[0..6]==" Para N" or
               next_sibling.inspect[0..6]=="<script" or
               next_sibling.inspect[0..6]=="<noscri" or
               next_sibling.inspect[0..3]=="<!--"
    
          all_content_until_next_header+= next_sibling.inspect
          all_content_until_next_header_text_only+= next_sibling.text
        end
        
        next_sibling = next_sibling.next_sibling
      end
      new_main_element = AlthingiDocumentElement.new
      new_main_element.content = all_content_until_next_header
      new_main_element.content_text_only = all_content_until_next_header_text_only
      new_main_element.sequence_number = sequence_number+=1
      new_main_element.parent_id = new_parent_header_element.id
      new_main_element.document_id = document_id
      new_main_element.set_content_type_for_main_content
      new_main_element.original_version=true
      new_main_element.save
      elements << new_main_element
    end

    for element in elements
      puts "Element sequence number: #{element.sequence_number}"
      puts "Element content type: #{element.content_type_s} - #{element.content_type}"
      puts "Element content number: #{element.content_number}"
      puts "#{element.content_text_only}"
      puts "---------------------------------------------------------------------------------"
    end
    
    puts "HTML"
    
    for element in elements
      puts "#{element.content}"
    end
  end

  # All Icelandic Laws from 1961 http://www.althingi.is/altext/stjtnr.html

  def get_stage_sequence_number(txt)
    re1='(\\d+)'  # Integer Number 1
    re2='(\\.)' # Any Single Character 1
    re3='(\\s+)'  # White Space 1
    re4='(umræða)' # Word 1
    
    re=(re1+re2+re3+re4)
    m=Regexp.new(re,Regexp::IGNORECASE);
    if m.match(txt)
        int1=m.match(txt)[1];
    end
    
    return int1
  end

  def get_case(url, presenter, external_id, external_name)      
   html_doc = nil
   retries = 10
   begin
     Timeout::timeout(120){
       html_doc = Nokogiri::HTML(open(url))
     }
   rescue
     retries -= 1
     if retries > 0
       sleep 0.42 and retry
       puts "retry"
     else
       raise
     end
   end

   current_case = Case.new
   current_case.info_1 = (html_doc/"span.Fyrirsogn").text.strip
   current_case.info_2 = (html_doc/"span.FyrirsognSv").text.strip
   current_case.external_link = url
   current_case.presenter = presenter
   current_case.external_id = external_id
   current_case.external_name = external_name

   puts "***************************************** New Case *****************************************"
   puts "Case info 1: "+(html_doc/"span.Fyrirsogn").text.strip
   puts "Case info 2: "+(html_doc/"span.FyrirsognSv").text.strip
   (html_doc/"span.FyrirsognSv").each do |info|
     puts "Case info 3: "+ info.next_sibling.next_sibling.text.strip
     current_case.info_3 = info.next_sibling.next_sibling.text.strip
   end

   old_case = Case.find_by_external_link(url)
   if old_case
     current_case = old_case
     puts "OLD CASE: "+current_case.inspect
   else
     current_case.save
     puts current_case.inspect
   end

   document_sequence_number = 0
   discussion_sequence_number = 0
   if (html_doc/"div.FyrirsognMidSv").text==""
     next_sibling=html_doc.xpath('/html/body/table/tr[2]/td/table/tr/td[2]/div/table')
     puts "============"      
     puts next_sibling.at("tr[1]/td[1]").text
     puts "============"
     stage_sequence_number = 0
     if next_sibling.at("tr[1]/td[1]").text=="Þingskjöl"
       tr_count = 3
       while next_sibling.at("tr[#{tr_count}]/td[1]")
         case_document = CaseDocument.new
         case_document.sequence_number=document_sequence_number+=1
         case_document.case_id = current_case.id
         case_document.stage_sequence_number = stage_sequence_number
         puts "Date: "+next_sibling.at("tr[#{tr_count}]/td[1]").text.strip
         case_document.external_date = DateTime.strptime(next_sibling.at("tr[#{tr_count}]/td[1]").text.strip, "%d.%m.%Y")
         if next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")
           puts "Document Id: "+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]").text.strip
           case_document.external_id = next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]").text.strip
           puts "Document URL: http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")['href']
           case_document.external_link = "http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")['href']
         end
         if next_sibling.at("tr[#{tr_count}]/td[3]").text
           puts "Document Type: "+next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
           case_document.external_type = next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
         else
           puts "Document Type: unkown"
         end
         if next_sibling.at("tr[#{tr_count}]/td[4]").text
           puts "Document Author: "+next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
           case_document.external_author = next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
         else
           puts "Document Author: unkown"
         end
         unless oldcd = CaseDocument.find_by_external_link(case_document.external_link)
           case_document.save
           puts "EXTERNAL_TYPE: " + case_document.external_type
           puts "EXTERNAL_TYPE START3: " + case_document.external_type[0..3]
           if  ["stjfrv.","frv. eftir 2. umr.","frv. eftir 3. umr.","lög í heild",
               "frv. prentað upp","frv.","frv. n.","frv. n. prentað upp","stjfrv. prentað upp"].include?(case_document.external_type)
             get_document(case_document.case_id, case_document.id, case_document.external_link)
           elsif case_document.external_type[0..3]=="lög"
             get_law_document(case_document.case_id, case_document.id, case_document.external_link)
           end
           puts case_document.inspect
         else
           puts "Found old case document: " + oldcd.inspect
         end
         tr_count+=1
         puts ""
       end
     end
   else
     (html_doc/"div.FyrirsognMidSv").each do |row|
        # Case stage_sequence
       puts row.text.strip
       stage_sequence_number = get_stage_sequence_number(row.text.strip)
       puts "---------------------"      
       next_sibling = row.next_sibling
       while next_sibling and next_sibling.inspect[0..3]!="<div"
         if next_sibling.inspect[0..5]=="<table"
           puts "============"      
           puts next_sibling.at("tr[1]/td[1]").text
           puts "============"
           if next_sibling.at("tr[1]/td[1]").text=="Þingskjöl"
             tr_count = 3
             while next_sibling.at("tr[#{tr_count}]/td[1]")
               case_document = CaseDocument.new
               case_document.sequence_number=document_sequence_number+=1
               case_document.case_id = current_case.id
               case_document.stage_sequence_number = stage_sequence_number
               puts "Date: "+next_sibling.at("tr[#{tr_count}]/td[1]").text.strip
               case_document.external_date = DateTime.strptime(next_sibling.at("tr[#{tr_count}]/td[1]").text.strip, "%d.%m.%Y")
               if next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")
                 puts "Document Id: "+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]").text.strip
                 case_document.external_id = next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]").text.strip
                 puts "Document URL: http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")['href']
                 case_document.external_link = "http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")['href']
               end
               if next_sibling.at("tr[#{tr_count}]/td[3]").text
                 puts "Document Type: "+next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
                 case_document.external_type = next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
               else
                 puts "Document Type: unkown"
               end
               if next_sibling.at("tr[#{tr_count}]/td[4]").text
                 puts "Document Author: "+next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
                 case_document.external_author = next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
               else
                 puts "Document Author: unkown"
               end
               unless oldcd = CaseDocument.find_by_external_link(case_document.external_link)
                 case_document.save
                 puts "EXTERNAL_TYPE: " + case_document.external_type
                 puts "EXTERNAL_TYPE START3: " + case_document.external_type[0..3]
                 if  ["stjfrv.","frv. eftir 2. umr.","frv. eftir 3. umr.","lög í heild",
                     "frv. prentað upp","frv.","frv. n.","frv. n. prentað upp","stjfrv. prentað upp"].include?(case_document.external_type)
                   get_document(case_document.case_id, case_document.id, case_document.external_link)
                 elsif case_document.external_type[0..3]=="lög"
                   get_law_document(case_document.case_id, case_document.id, case_document.external_link)
                   sleep 1
                 end
                 puts case_document.inspect
               else
                 puts "Found old case document: " + oldcd.inspect
               end
               tr_count+=1
               puts ""
             end
           elsif (next_sibling.at("tr[1]/td[1]").inner_html)=="Umræða"
             tr_count = 3
             while next_sibling.at("tr[#{tr_count}]/td[1]")
               case_discussion = CaseDiscussion.new
               case_discussion.sequence_number=discussion_sequence_number+=1
               case_discussion.case_id = current_case.id
               case_discussion.stage_sequence_number = stage_sequence_number
               if next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0]
                 puts "Discussion Time: "+next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0].text.strip
                 date_from_time = next_sibling.at("tr[#{tr_count}]/td[2]").text.strip + " " + next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0].text.strip[0..4]
                 date_to_time = next_sibling.at("tr[#{tr_count}]/td[2]").text.strip + " " + next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0].text.strip[6..10]
                 case_discussion.from_time = DateTime.strptime(date_from_time, "%d.%m.%Y %H:%M")
                 case_discussion.to_time = DateTime.strptime(date_to_time, "%d.%m.%Y %H:%M")
                 puts "Discussion Time URL: http://www.althingi.is"+next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0]['href']
                 case_discussion.transcript_url="http://www.althingi.is"+next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[0]['href']
               end
               if next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[1]
                 puts "Listen URL: "+next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[1]['href']
                 case_discussion.listen_url=next_sibling.search("tr[#{tr_count}]/td[1]/a[@href]")[1]['href']
               end
               puts "Date: "+next_sibling.at("tr[#{tr_count}]/td[2]").text.strip
               case_discussion.meeting_date = DateTime.strptime(next_sibling.at("tr[#{tr_count}]/td[2]").text.strip, "%d.%m.%Y")
               if next_sibling.at("tr[#{tr_count}]/td[3]").text
                 puts "Meeting Type: "+next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
                 case_discussion.meeting_type = next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
               else
                 puts "Meeting Type: unkown"
               end
               if next_sibling.at("tr[#{tr_count}]/td[4]").text
                 puts "Meeting Info "+next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
                 case_discussion.meeting_info = next_sibling.at("tr[#{tr_count}]/td[4]").text.strip
                 if next_sibling.at("tr[#{tr_count}]/td[4]/a[@href]")
                   puts "Meeting URL: http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[4]/a[@href]")['href']
                   case_discussion.meeting_url = "http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[4]/a[@href]")['href']
                 end
               else
                 puts "Meeting Number: unkown"
               end
               puts ""
               unless oldcd = CaseDiscussion.find(:first, :conditions => ["listen_url = ? AND transcript_url = ?", 
                                                                    case_discussion.listen_url, case_discussion.transcript_url])
                 case_discussion.save
                 puts case_discussion.inspect
               else
                 puts "Found old case discussion: " + oldcd.inspect
               end
               tr_count+=1
             end
           end
           puts "++++++++++++"
         end
         next_sibling = next_sibling.next_sibling
       end
       puts "---------------------"      
     end
   end
 end

 def update_all_cases
   html_doc = Nokogiri::HTML(open('http://www.althingi.is/vefur/thingmalalisti.html?cmalteg=l'))

   next_sibling = html_doc.xpath('/html/body/table/tr[2]/td/table/tr/td/table[2]/tr/td[2]/div/table')
   puts "============"      
   
   tr_count = 2
   while next_sibling.at("tr[#{tr_count}]/td[1]")
     external_case_id = next_sibling.at("tr[#{tr_count}]/td[1]").text.strip
     puts "External Case Id:"+external_case_id
     case_name = ""
     case_name+=next_sibling.at("tr[#{tr_count}]/td[2]").text.strip
     case_url = "http://www.althingi.is"+next_sibling.at("tr[#{tr_count}]/td[2]/a[@href]")['href']
     puts "Case URL: "+case_url
     if next_sibling.at("tr[#{tr_count}]/td[2]/a[@title]") and
        next_sibling.at("tr[#{tr_count}]/td[2]/a[@title]")['title']!=""
       case_name+=" ("+next_sibling.at("tr[#{tr_count}]/td[2]/a[@title]")['title'].strip+")"
     end
     puts "Case name: "+case_name      
     case_author = ""
     case_author+=next_sibling.at("tr[#{tr_count}]/td[3]").text.strip
     if next_sibling.at("tr[#{tr_count}]/td[3]/a[@title]") and 
        next_sibling.at("tr[#{tr_count}]/td[3]/a[@title]")['title']!=""
       case_author+=" ("+next_sibling.at("tr[#{tr_count}]/td[3]/a[@title]")['title'].strip+")"
     end
     puts "Case author: "+case_author
     tr_count+=1
     get_case(case_url, case_author, external_case_id, case_name)
     sleep 1
     puts ""
   end
  end
end

acrawler = AlthingiCrawler.new
acrawler.update_all_cases
