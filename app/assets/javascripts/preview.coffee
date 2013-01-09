timeout = 0

$ ->
  $("textarea#body").keyup (e) ->
    window.clearTimeout timeout
    timeout = window.setTimeout ->
      $.post "/admin/posts/preview", $(e.target).parents("form").serialize(), (data, status, xhr) ->
        $(".preview").html(data)
    , 1000