# contains all the file accessing for verifier.rb
class FileHelper
  attr_reader :lines
  def initialize(file_name)
    @file_name = file_name
    @lines = []
  end

  # gets an array of the lines in the file
  def file_lines
    if File.exist?(@file_name)
      file_reader = File.open(@file_name, 'r')
      file_reader.each_line do |line|
        @lines.push line
      end
      file_reader.close
      @lines
    else
      raise "File '#{@file_name}' does not exist"
    end
  end
end
