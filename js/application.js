$(function() {

  // Image Zoomer
  //-------------
  // $('.article-image > a').magnificPopup({type: 'image'});

  // Footnote Scrolling
  $("a[rel='footnote'], a[rev='footnote']").click(function() {
    $('html, body').animate({
        scrollTop: $($(this).attr('href')).offset().top
    }, 1000);
  });

  // Progress bar indicator
  // ----------------------
  // This takes the height of an article and then scrolls displays the ammount left in a progressbar element.
  // See https://css-tricks.com/reading-position-indicator/
  // Note that the user is actually scrolling the #container element rather than the body,
  //  because of a bug in webkit that reports $(document.body).scrollTop as 0. We can't scroll the
  //  document because we have x-overflow: hidden (to prevent scrolling when the sidebar is shown).
   var winHeight = $(window).height(),
        docHeight = $(".c-article").height(),
        progressBar = $('.c-reading-progress-indicator'),
        max, value;

    // Set the max scrollable area
    max = docHeight - winHeight;
    progressBar.attr('max', max);

    // Recalculate and refill the progressbar when the user resizes.
    $(window).on('resize', function() {
      winHeight = $(window).height(),
      docHeight = $(".c-article").height();

      max = docHeight - winHeight;
      progressBar.attr('max', max);

      value =  $('#container').scrollTop();
      progressBar.attr('value', value);
    });

    // Fill the progress bar when the user scrolls.
    $('#container').scroll(function(){
      value = $('#container').scrollTop();
      progressBar.attr('value', value);
    });

    // Possible fix for mobile problems
    $('#container').bind('touchmove', function(){
      value = $('#container').scrollTop();
      progressBar.attr('value', value);
    });


    // Disable pointer events when scrolling
    //--------------------------------------
    var body = document.body,
    timer;

    window.addEventListener('scroll', function() {
      clearTimeout(timer);
      if(!body.classList.contains('u-disable-hover')) {
        body.classList.add('u-disable-hover')
      }

      timer = setTimeout(function(){
        body.classList.remove('u-disable-hover')
      },500);
    }, false);
});
