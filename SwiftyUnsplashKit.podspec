Pod::Spec.new do |spec|

  spec.name = "SwiftyUnsplashKit"
  spec.version = "0.0.4"
  spec.summary = "Pod written in Swift kit used to present Unsplash search view and select image along with its url."

  spec.description = <<-DESC
  Lightweight Swift kit used to present Unsplash search view and select image along with its url. This is done via a modular controller/presenter object called UnsplashSearchPresenter.
                   DESC

  spec.homepage  = "https://github.com/everuribe/SwiftyUnsplashKit"

  spec.license = { :type => "MIT", :file => "LICENSE" }

  spec.author = { "Ever" => "e.apollo.u@gmail.com" }

  spec.ios.deployment_target = "12.0"

  spec.swift_version = "4.2"

  spec.source = { :git => "https://github.com/everuribe/SwiftyUnsplashKit.git", :tag => "#{spec.version}" }

  spec.source_files = "SwiftyUnsplashKit/**/*.{h,m,swift}"

  spec.resources = "SwiftyUnsplashKit/*.xcassets"

end

