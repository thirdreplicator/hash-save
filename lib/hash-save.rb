require 'fileutils'

class Hash
  BASE_DIR = './data'

  def save_as(namespace)
    save("#{BASE_DIR}/#{namespace}")
  end

  alias :save_in :save_as

  def load_from(namespace)
    load("#{BASE_DIR}/#{namespace}") 
  end

  def self.load_from(namespace)
    files = Dir.entries("#{BASE_DIR}/#{namespace}")[2..-1]
    h = {}
    files.each do |fn|
      h[fn.to_sym] = find(fn, "#{BASE_DIR}/#{namespace}")
    end
    h
  end

  def save(base_dir=BASE_DIR)
    self.each do |k,v|
      File.open("#{base_dir}/#{k}", 'wb') do |f|
        Marshal.dump(v, f)
      end
    end

    rescue Errno::ENOENT => e
      before = Dir.exists?(base_dir)
      FileUtils.mkdir_p(base_dir)
      after = Dir.exists?(base_dir)
      if before == false && after == true
        retry 
      else
        raise e
      end
  end

  def load!(base_dir=BASE_DIR)
    self.each do |k,v|
      self[k] = self.class.find!(k, base_dir)
    end
  end

  def self.find!(k, base_dir=BASE_DIR)
    File.open("#{base_dir}/#{k}", 'rb') do |f|
      Marshal.load(f)
    end
  end

  def load(base_dir=BASE_DIR)
    self.each do |k,v|
      self[k] = self.class.find(k, base_dir)
    end
  end

  def self.find(k, base_dir=BASE_DIR, default_val=nil)
    begin
      self.find!(k, base_dir)
    rescue Errno::ENOENT => e
      default_val
    end
  end

  def self.modify!(k, base_dir=BASE_DIR)
    {k => yield(Hash.find(k, base_dir))}.save
  end

  def self.inc!(k, base_dir=BASE_DIR)
    modify!(k, base_dir){ |x| x + 1 }
  end
end
