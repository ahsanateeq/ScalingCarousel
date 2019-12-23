
Pod::Spec.new do |spec|

  spec.name         = "ScalingCarousel"
  spec.version      = "1.3.10"
  spec.summary      = "This is a simple ScalingCarousel."

  spec.description  = <<-DESC
	This is a simple Scaling Carousel, I will provide implementation later
                   DESC

  spec.homepage     = "https://github.com/ahsanateeq/ScalingCarousel"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Ahsan Ateeq" => "ahsan.ateeq1@outlook.com" }
  
  spec.ios.deployment_target = "10.0"
  spec.swift_version = "5.0"
  
  spec.source       = { :git => "https://github.com/ahsanateeq/ScalingCarousel.git", :tag => "#{spec.version}" }


  spec.source_files  = "Classes/*"

end
