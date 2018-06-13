Pod::Spec.new do |s|
  s.name = 'METableViewAnimation'
  s.version = '0.0.2'
  s.license = 'MIT'
  s.summary = 'Collection of tableview animation in swift'
  s.homepage = 'https://github.com/melody5417/METableViewAnimation'
  s.authors = { "yiqiwang(王一棋)" => "yiqiwang@tencent.com" }
  s.source       = { :git => "https://github.com/melody5417/METableViewAnimation.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '9.0'

  s.swift_version = '4.1'
  s.source_files = 'Source/*.swift'
end
