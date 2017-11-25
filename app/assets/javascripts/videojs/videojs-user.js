$(document).ready(function(){
	videojs('my-video').ready(function() {
		this.hotkeys({
			volumeStep: 0.1,
			seekStep: 5,
			enableModifiersForNumbers: false
		});
		this.overlay();
	});

});
