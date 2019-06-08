
Pod::Spec.new do |s|
  s.name         = "RNJonbrenneckeFarrago"
  s.version      = "1.0.0"
  s.summary      = "RNJonbrenneckeFarrago"
  s.description  = <<-DESC
                  RNJonbrenneckeFarrago
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNJonbrenneckeFarrago.git", :tag => "master" }
  s.source_files  = "RNJonbrenneckeFarrago/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  