# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(".toggle_configurations").click ->
    $(".app_configuration, .effective_configuration").toggle()
    false
    
  if $("select#app_ec2_sg_to_authorize").length
    $.getJSON $("select#app_ec2_sg_to_authorize").attr("data-agifogurl"), (data) ->
      items = []
      $.each data, (index, val) ->
        items.push "<option value=\"" + val + "\">" + val + "</option>"
  
      $("select#app_ec2_sg_to_authorize >option").remove()
      $("select#app_ec2_sg_to_authorize").append "<option value=\"\"></option>"
      $("select#app_ec2_sg_to_authorize").append items.join("")