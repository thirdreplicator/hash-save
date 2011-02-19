class Hash
  BASE_DIR = './data'

  def save
    self.each do |k,v|
      File.open("#{BASE_DIR}/#{k}", 'wb') do |f|
        Marshal.dump(v, f)
      end
    end
    rescue Errno::ENOENT
      Dir.mkdir(BASE_DIR)
      retry if Dir.exists(BASE_DIR)
  end

  def self.find(k)
    File.open("#{BASE_DIR}/#{k}", 'rb') do |f|
      Marshal.load(f)
    end
  end

  def self.modify(k)
    {k => yield(Hash.find(k))}.save
  end

  def self.inc(k)
    modify(k){|x| x + 1}
  end

  def self.inc!(k)
    modify(k){|x| x + 1}.save
  end
end
