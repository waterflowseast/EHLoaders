Pod::Spec.new do |s|
  s.name             = 'EHLoaders'
  s.version          = '1.0.0'
  s.summary          = 'pull to refresh & lift to load more.'
  s.homepage         = 'https://github.com/waterflowseast/EHLoaders'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Huang' => 'WaterFlowsEast@gmail.com' }
  s.source           = { :git => 'https://github.com/waterflowseast/EHLoaders.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'EHLoaders/Classes/**/*'
end
