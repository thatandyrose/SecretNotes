do showSubmitter = ->
  init = ->
    $(".show-note-form input[type='submit']").on 'click', (e) ->
      e.preventDefault()
      me = $(this)
      form = me.closest('form')
      form.attr('action', form.attr('action') + '/' + $('#id').val())
      $('#id').remove()
      form.submit()


  $(document).on 'page:load', -> init()
  $(document).ready -> init()
  {}