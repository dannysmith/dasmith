$(function() {

  // Image Zoomer
	$('.article-image > a').magnificPopup({type: 'image'});

  // Footnote Scrolling
  $("a[rel='footnote'], a[rev='footnote']").click(function() {
    $('html, body').animate({
        scrollTop: $($(this).attr('href')).offset().top
    }, 1000);
  });

});
