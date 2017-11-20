//$(function () {
//  $('[data-toggle="popover"]').popover()
//})
//$(function () {
//  $('[data-toggle="tooltip"]').tooltip()
//})

$(document).on("ready page:change", function() {
  $("[data-toggle='tooltip']")
    .tooltip("destroy")
    .tooltip();
  $('[data-toggle="popover"]')
    .popover("destroy")
    .popover();
});
