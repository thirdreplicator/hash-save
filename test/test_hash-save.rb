$LOAD_PATH << File.join(File.dirname( File.expand_path(__FILE__)), '..', 'lib')
require 'hash-save'
require 'rspec'

describe Hash do 

  before :each do
    `rm -rf ./data`
  end

  it "should be able to save a key's values." do
    {:a => 1}.save
    Hash.find(:a).should == 1
  end

  it "should be able to save a key's values (strings)." do
    {:a => "pizza"}.save
    Hash.find(:a).should == "pizza"
  end

  it "should be able to save a key's values (arrays)." do
    {:a => ["pizza", 42]}.save
    Hash.find(:a).should == ["pizza", 42]
  end

  it "should be able to save a key's values (hashes)." do
    {:a => {"pizza" => 42}}.save
    Hash.find(:a).should == {"pizza" => 42}
  end

  it "should create a data directory if one doesn't exist" do
    Dir.exists?('data').should be_false
    {:a => 1}.save
    Dir.exists?('data').should be_true
  end

  it "should be able to take single-argument function to create a new modified hash instance based on its saved value." do
    {:a => 42}.save
    Hash.modify!(:a){ |x| 10 + x }
    Hash.find(:a).should == 52
    # The version on disk should have changed.
    Hash.find(:a).should == 52
  end

  it "should be able to increment integer values" do
    {:a => 42}.save
    Hash.inc!(:a).should == {:a => 43}
    # The version on disk should have changed.
    Hash.find(:a).should == 43
  end

  it "should be able to reload key values" do
    {:a => 1, :b => 2}.save
    h = {:a => nil, :b => nil}.load!
    h[:a].should == 1
    h[:b].should == 2
  end

  it "should be able to reload key values" do
    {:a => 1, :b => 2}.save
    h = {:a => nil, :b => nil, :c => "burgers"}.load
    h[:a].should == 1
    h[:b].should == 2
    h[:c].should == nil
  end

  it "should be able to save data in a separate namespace using 'save_as'" do
    {:x => 100, :y => 200}.save_as("xyz")
    xyz = Hash.load_from("xyz")
    xyz[:x].should == 100
  end

  it "should be able to save data in a separate namespace using 'save_in'" do
    #{:x => 1, :y => 2}.save
    #abc = Hash.load
    #abc[:x].should == 1
    {:x => 100, :y => 200}.save_in("xyz")
    xyz = Hash.load_from("xyz")
    xyz[:x].should == 100
  end

  it "should be able to load an individual value rather than an entire directory" do
    {:x => 100, :y => 200}.save_in("xyz")
    xyz = {:x => nil}.load_from("xyz")
    xyz[:x].should == 100
  end
end
