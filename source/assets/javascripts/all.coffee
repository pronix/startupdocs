#= require jquery
#= require_tree .

$ ->
  $('#mc-embedded-subscribe').on 'click', ->
    $('#mc-embedded-subscribe-form').hide()
    $('.frontpage-success-msg').show()
