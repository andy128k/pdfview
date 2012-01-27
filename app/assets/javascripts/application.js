// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function(){
  function fitTextInBox(box, maxHeight) {
    var maxWidth = box.offsetWidth;
    maxHeight = maxHeight || 10000;

    var textObj = box.getElementsByTagName('SPAN')[0];
    textObj.style.fontSize = '1px';

    var currentWidth = textObj.offsetWidth;
    while (true) {
      var fontSize = increaseFont(textObj, 1);
      var tmpWidth = textObj.offsetWidth;
      var tmpHeight = textObj.offsetHeight;

      if (tmpWidth >= currentWidth && tmpWidth < maxWidth && tmpHeight < maxHeight && fontSize < 300) {
          currentWidth = textObj.offsetWidth;
      } else {
        increaseFont(textObj, -1);
        break;
      }
    }
  }

  function increaseFont(obj, delta) {
    var fontSize = parseInt(obj.style.fontSize.replace('px', ''), 10);
    fontSize += delta;
    obj.style.fontSize = fontSize + 'px';
    return fontSize;
  }

  $('.text').each(function(){
    fitTextInBox(this);
  });
});

