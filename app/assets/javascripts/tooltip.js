//$(function () {
//  $('[data-toggle="popover"]').popover()
//})
//$(function () {
//  $('[data-toggle="tooltip"]').tooltip()
//})

$(document).on("turbolinks:load", function() {
  $("[data-toggle='tooltip']")
    .tooltip("destroy")
    .tooltip();
  $('[data-toggle="popover"]')
    .popover("destroy")
    .popover();
});
