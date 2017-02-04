Gem::Specification.new do |s|
  s.name  = "vend_endpoint"
  s.version = "0.0.1"

  s.summary = "Cangaroo endpoint for Vend POS"
  s.description = ""

  s.authors = ["Joe Lind"]
  s.email = "joe@shopfollain.com"
  s.homepage = "http://shopfollain.com"

  s.files = ([`git ls-files lib/`.split("\n")]).flatten

  s.test_files = `git ls-files spec/`.split("\n")

  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'tilt', '~> 1.4.1'
  s.add_runtime_dependency 'tilt-jbuilder'
  s.add_runtime_dependency 'httparty'
  s.add_runtime_dependency 'peach'
end
