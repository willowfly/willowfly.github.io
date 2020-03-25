$('.a-share, .a-share2').each(function(){
	var id = $(this).data('id');
	$('a', this).click(function(){

		var summary = '';
		var description;
		var metas = document.getElementsByTagName('meta');
		for (var x=0,y=metas.length; x<y; x++) {
		  if (metas[x].name.toLowerCase() == "description") {
		    description = metas[x];
		  }
		}
		if( description ) summary = description.content;
		var title = document.title;
		var url = document.location.href;
		var app = $(this).data('app');
		share_url(app, url, title, summary);

	});
});