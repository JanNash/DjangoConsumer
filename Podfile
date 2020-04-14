platform :ios, '8.0'


target 'DjangoConsumer' do
  pod 'Alamofire', '4.8.1'
  pod 'SwiftyJSON', '4.0.0'
  pod 'xcbeautify', '0.7.5'

  target 'DjangoConsumerTests' do
    inherit! :search_paths
  end
end


target 'ExampleApp' do
  pod 'DjangoConsumer', :subspecs => ['Core', 'OAuth2'], :path => '.'
end
