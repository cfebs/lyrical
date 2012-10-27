
var _Google = function() {
  this.test = 'hello';
  this.container = null;

  this.init = function() {
    this.container = $('<div id="scratch"></div>').appendTo('body');
    this.dump = $('<div />').appendTo(this.container);
    //this.container.hide();
  }

  this.search = function() {
    $.ajax({
      url: '/search/' + this.buildQuery('test'),
      success: function(data) {
        this.dump.html(data);
        this.dump
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

var Google = new _Google();
Google.search();
