# contains all the file accessing for verifier.rb
class FileHelper
  attr_reader :lines
  def initializer(fileName)
    @fileName = fileName
    @lines = Array.new
  end

  # gets an array of the lines in the file
  def get_file_lines
    fReader = File.open(@fileName, 'r')
    fReader.each_line do |line|
      @lines.push line
    end
  end
end
