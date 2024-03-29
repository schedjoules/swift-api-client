Pod::Spec.new do |s|
  s.name             = 'SchedJoulesApiClient'
  s.version          = '0.8.2'
  s.summary          = 'The ApiClient for the SchedJoules API, written in Swift.'
 
  s.description      = <<-DESC
This pod contains classes which make it easier to interact with the SchedJoules API. Our SDK also uses the ApiClient, but if one does not need the full functionality of the SDK, or wants to build custom solutions instead, might find the ApiClient to be a good starting point.
                       DESC
 
  s.homepage         = 'https://github.com/schedjoules/swift-api-client'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Balazs Vincze' => 'sayhello@bvincze.com' }
  s.source           = { :git => 'https://github.com/schedjoules/swift-api-client.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  s.source_files = 'ApiClient/Source/**/*.swift'
 
end
