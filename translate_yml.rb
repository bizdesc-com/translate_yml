require 'json'
require 'open-uri'

class TranslateYml
    
  @@lines = Hash.new
  
  def initialize()
    
  end   
    
  def read_file_and_translate(path, from, to)
    
    begin  
      char = File.open(path).read
      char.gsub!(/\r\n?/, "\n")
      
      char.each_line do |line|
        tokens = line.split(':')
        
        if !tokens[1].lstrip.empty?
          lst = tokens[1].lstrip.rstrip
          
          url = "http://mymemory.translated.net/api/get?q="+ lst +"&langpair="+ from +"|"+ to +"&format=json"
          
          encoded_uri = URI.encode(url)
          parsed_uri = URI.parse(encoded_uri) 
          
          # Actually fetch the contents of the remote URL as a String.
          buffer = open(parsed_uri).read
          json_object = JSON.parse(buffer)
          translated_char = json_object["responseData"]["translatedText"]
              
          @@lines[tokens[0]] = translated_char
        else
          if tokens[0].eql? from 
            @@lines[to] = tokens[1] 
          else 
             @@lines[tokens[0]] = tokens[1] 
          end     
        end        
      end
      
    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect  
    end  
     
    new_file = path.gsub!('en', 'it') 
    
    @@lines.each do |key, value|      
      begin
        File.open(new_file, 'w') { |file| 
          file.puts(key.to_s+ ': ' +value)
        } 
      rescue Exception => e  
        puts e.message  
        puts e.backtrace.inspect  
      end    
    end
      
  end
  
    
end

trans_yml = TranslateYml.new
trans_yml.read_file_and_translate('/home/birhanuh/workspace/fuzu_translate/data/en.yml', 'en', 'it')

