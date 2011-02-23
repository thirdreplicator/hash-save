Gem::Specification.new do |s|
  s.name                     = "hash-save"
  s.version                  = "0.0.7"
  s.summary                  = "Save your hashes a marshalled file."
  s.description              = "{:a => 1, :b => 2}.save\nx = Hash.find(:a) # 1"
  s.homepage                 = "http://github.com/thirdreplicator/hash-save"
  s.authors                  = ["David Beckwith"]
  s.email                    = "thirdreplicator@gmail.com"
  s.require_paths            = ["lib"] 
  s.files                    = ["lib/hash-save.rb"]
  s.rubyforge_project        = "nowarning"
end
