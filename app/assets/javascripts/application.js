// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap-select
//= require typeahead.js/dist/bloodhound.js
//= require typeahead.js/dist/typeahead.bundle.js
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip({ html: true });
  $('.selectpicker').selectpicker();
  var bestPictures = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/search?query=%QUERY',
      wildcard: '%QUERY'
    }
  });

  $('#search').typeahead(null, {
    name: 'best-pictures',
    display: 'name',
    source: bestPictures
  });
})