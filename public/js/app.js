
var Util = {
  notify: function(s, c) {
    var c= $.type(c) == 'undefined' ? c: 'info'
    var n = $('#notice p span:first')
    n.html(s);
    n.addClass(c);
    n.fadeIn().delay(1000).fadeOut();
  }
};

////////////////////

var _Google = function() {
  this.container = null;
  this.spinner = $('#spinner');

  this.init = function() {
    this.container = $('<div id="scratch"></div>').appendTo('body');
    this.dump = $('<div id="dump" />').appendTo(this.container);
    this.result = $('#result');
    this.spinner.hide();

    //this.container.hide();
  }

  this.search = function(str) {
    this.spinner.show();
    this.result.hide();
    $.ajax({
      url: '/search/' + this.buildQuery(str),
      success: function(data) {
        this.result.html(data);
        //console.log(data);
        //this.result.html(data);
        //var links = $.parseJSON(data);
        this.result.show();
        this.spinner.hide();
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
    var v = $('#query').val();
    if (!v)
      Util.notify('Please type something');
    else
      Google.search(v);
  }

  $('#query').keypress(function(e) {
       if(e.which == 13) showMoney();
  });
  $('#go').click(showMoney);

  $('#about').click(function() {
    $('#dialog-modal').dialog({
      modal: true,
      draggable: false,
      resizeable: false,
      width: 800
    });
  });
});
