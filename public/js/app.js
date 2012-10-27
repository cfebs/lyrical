
var Util = {
  notify: function(s, c) {
    var c= $.type(c) == 'undefined' ? c: 'info'
    var n = $('#notice p:first')
    n.html(s);
    n.addClass(c);
    n.show().wait(20).fadeOut();
  }
};

////////////////////

var _Google = function() {
  this.test = 'hello';
  this.container = null;

  this.init = function() {
    this.container = $('<div id="scratch"></div>').appendTo('body');
    this.dump = $('<div id="dump" />').appendTo(this.container);

    //this.container.hide();
  }

  this.search = function(str) {
    $.ajax({
      url: '/search/' + this.buildQuery(str),
      dataType: 'html',
      success: function(data) {
        this.dump.html(data);
      }.bind(this)
    });
  }

  /**
   * Builds the google search query
   */
  this.buildQuery = function(q) {
    return q;
  }

  this.init();
};


// events
var Google = new _Google();
$(function(){

  var showMoney = function() {
    Google.search($('#query').val());
  }

  $('#query').keypress(function(e) {
       if(e.which == 13) showMoney();
  });
  $('#go').click(showMoney);
});
