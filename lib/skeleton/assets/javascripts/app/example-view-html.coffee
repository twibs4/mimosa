define ['jquery'], ($) ->

  class ExampleView

    render: (element) ->
      $(element).append "<div class='name'>This is coming directly from a view, not from a micro template.</div>"
      $(element).append "<div class='styled'>And its all been styled (poorly) using CSSHERE</div>"

  ExampleView