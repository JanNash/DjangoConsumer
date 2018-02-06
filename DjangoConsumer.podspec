
Pod::Spec.new do |s|
  s.name = "DjangoConsumer"
  s.version = "0.0.1"
  s.summary = "A Swift framework trying to make swiftly consuming a Django Rest Framework API quite effortless."
  s.description = <<-DESC 
                  DjangoConsumer (or DRFAFI?) is a small assemblage of protocols and structs that should be useful
                  to communicate with a Django Rest Framework API through a simple, hopefully quite swifty interface.

                  You define your models, make them conform to one small protocol, write a few lines of general 
                  configuration and get started with consuming your DRF API.

                  // TODO: Add code examples

                  More detailed configurations configurations are possible if necessary.

                  // TODO: Add code examples

                  DESC
  s.homepage = "https://github.com/JanNash/DjangoConsumer"
  s.license = { 
    :type => "BSD-3-Clause",
    :file => "LICENSE"
  }
  s.authors = {
    "Jan Nash" => "jnash@jnash.de" 
  }
  s.platform = :ios, "9.0"
  s.source = {
    :git => "https://github.com/resmio/DjangoConsumer.git",
    :tag => "v#{s.version}"
  }
  s.dependency 'Alamofire-SwiftyJSON', '~> 3.0.0'
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = "DjangoConsumer/Source/Core/**/*.swift"
  end
  
  s.subspec 'OAuth2' do |oauth2|
      core.source_files = "DjangoConsumer/Source/OAuth2/**/*.swift"
  end
  
  s.subspec 'MockBackend' do |mockbackend|
    mockbackend.source_files = "DjangoConsumer/Source/MockBackend/**/*.swift"
    mockbackend.dependency 'Embassy', '~> 4.0.0'
    mockbackend.dependency 'EnvoyAmbassador', '~> 4.0.1'
  end
end
