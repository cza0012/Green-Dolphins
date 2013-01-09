# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#question_tag_list').tokenInput '/tags.json'
    prePopulate: $('#question_tag_list').data('load')
    theme: 'facebook'
  
  $('div.controls').on 'click', 'textarea.text.required.input-block-level', (event) ->
    $(this).attr('rows', 2)
    
  $("[rel='tooltip nofollow']").tooltip()