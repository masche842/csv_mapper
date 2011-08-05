class CsvMapper::FileHandler

  attr_reader :path, :filename

  def initialize()
    @path =  File.join(Rails.root.to_s, "tmp")
  end

  def save_temp_file(tempfile)
    @filename = unique_filename
    FileUtils.copy_file(tempfile.path, file_path)
    File.exists?(file_path)
  end

  def load_file(filename)
    @filename = filename
    File.exist?(file_path)
  end

  def file_path
    File.join(@path, @filename)
  end

  def remove_file
    File.delete(file_path)
  end

private

  def unique_filename
    t = Time.now.strftime("%Y%m%d")
    "#{t}-#{$$}-#{rand(0x100000000000000).to_s(36)}"
  end

end