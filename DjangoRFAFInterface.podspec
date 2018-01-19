
Pod::Spec.new do |s|
  s.name = "DjangoRFAFInterface"
  s.version = "0.0.1"
  s.summary = "A Swift framework trying to make swiftly consuming a Django Rest Framework API quite effortless."
  s.description = <<-DESC 
                  DjangoRFAFInterface (or DRFAFI?) is a small assemblage of protocols and structs that should be useful
                  to communicate with a Django Rest Framework API through a simple, hopefully quite swifty interface.

                  You define your models, make them conform to one small protocol, write a few lines of general 
                  configuration and get started with consuming your DRF API.

                  // TODO: Add code examples

                  More detailed configurations configurations are possible if necessary.

                  // TODO: Add code examples

                  DESC
  s.homepage = "https://github.com/JanNash/DjangoRFAFInterface"
  s.license = { 
    :type => "BSD-3-Clause",
    :file => "LICENSE"
  }
  s.authors = {
    "Jan Nash" => "jnash@jnash.de" 
  }
  s.platform = :ios, "9.0"
  s.source = {
    :git => "https://github.com/resmio/DjangoRFAFInterface.git",
    :tag => "v#{s.version}"
  }
  s.source_files = "DjangoRFAFInterface/Source/**/*.swift"
  s.dependency 'Alamofire-SwiftyJSON', '~> 3.0.0'
end
