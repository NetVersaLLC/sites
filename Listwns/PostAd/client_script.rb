sign_in(data)
@browser.goto('http://www.listwns.com/post/post.aspx')

@browser.link(:text => "#{data['listwnsCity']}").when_present.click
@browser.link(:text => "#{data['adCategory1']}").when_present.click
@browser.link(:text => "#{data['adCategory2']}").when_present.click

@browser.text_field( :id => 'txt_title').set data[ 'adtitle' ]
@browser.text_field( :id => 'ta_content').set data[ 'adcontent' ]
@browser.text_field( :id => 'txt_phone').set data[ 'phone' ]
@browser.text_field( :id => 'txt_tag').set data[ 'tag' ]
@browser.file_field( :id => 'FileUpload1').set data[ 'image' ]

@browser.button( :id => 'btn_fabu').click
