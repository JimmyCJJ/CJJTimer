Pod::Spec.new do |s|

s.name 			= 'CJJTimer'
s.version 		= '1.0.9'
s.license		= { :type => 'MIT'}
s.summary		= 'CJJTimer是一个简单好用的定时器控件（短信、商品秒杀倒计时）'	
s.description 		= 'CJJTimer is a simple and easy to use timer control (SMS, countdown).'
s.homepage 		= 'https://github.com/JimmyCJJ/CJJTimer'
s.authors		= { 'JimmyCJJ' => '403327747@qq.com' }
s.social_media_url	= 'https://www.jianshu.com/u/fd9922e50c1a'
s.ios.deployment_target = '9.0'
s.source 		= { :git => 'https://github.com/JimmyCJJ/CJJTimer.git', :tag => s.version  }
s.frameworks = 'UIKit'
s.requires_arc = true
s.source_files = 'Example/CJJTimer/CJJTimer/*.{h,m}'
s.dependency 'Masonry'

end


