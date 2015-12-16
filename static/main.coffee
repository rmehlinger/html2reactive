{rx, rxStorage, _} = window
{session} = rxStorage
{cell, rxt, bind} = rx
{tags} = rxt

init = ->
  $translateBox = tags.textarea {
    id: 'translateBox'
    class: 'form-control'
    style: fontFamily: "monospace", marginBottom: 15
    value: session.getItem("lastText")
    change: -> session.setItem("lastText", $translateBox.val())
    rows: 20
    required: true
  }

  results = rx.cell("")
  hasError = rx.cell false

  $('body').append tags.div {class: 'container'}, [
    tags.div {class: 'row'}, tags.div {class: 'col-md-12'}, [
      tags.h1 "HTML to Reactive"
      tags.p [
        "A simple utility for converting HTML to the "
        tags.a {href: "http://yang.github.io/reactive-coffee/"}, "reactive-coffee"
        " templating language."
      ]
      tags.p tags.small [
        "Note: This package will not convert Javascript into coffee-script. "
        "Never include third-party Javascript without understanding what it does."
      ]
    ]
    tags.div {class: 'row'}, [
      tags.form {
        class: 'form col-sm-12'
        submit: (event) ->
          event.preventDefault()
          html = $translateBox.val()
          $.ajax(
            {
              url: '/translate'
              type: "POST",
              dataType: 'json',
              data: JSON.stringify({html})
              mimeType: 'application/json'
              contentType: "application/json; charset=ascii"
            }
          )
          .done((res) ->
            hasError.set false
            results.set(res.rc)
          ).fail( ->
            hasError.set true
          )
      }, [
        tags.div {class: bind -> ['row', if hasError.get() then "has-error" else '']}, tags.div {class: 'col-md-12'}, [
          tags.label {class: 'control-label h2', for: 'translateBox'}, "Enter HTML here"
          $translateBox
        ]
        tags.div {class: 'row'}, rx.flatten [
          bind ->
            if hasError.get() then tags.div {class: "col-md-4"}, tags.span {class: 'h3 text-danger'}, "Invalid HTML!"
            else ""
          tags.div {class: 'col-md-4 pull-right'}, tags.button {class: 'btn btn-primary btn-block btn-lg', type: 'submit'}, [
            "Translate!"
          ]
        ]
      ]
    ]
    tags.div {class: 'row'}, tags.div {class: 'col-sm-12', style: marginBottom: 30}, rx.flatten [
      tags.h2 "Reactive template"
      bind -> if not hasError.get() then tags.pre bind -> results.get() ? ""
    ]
    tags.div {class: 'row'}, tags.footer {class: 'col-sm-12'}, [
      tags.p [
        "This application written by "
        tags.a {href: "http://www.rmehlinger.com"}, "Richard Mehlinger"
        " and released under the "
        tags.a {href: "https://opensource.org/licenses/MIT"}, "MIT License"
        ". Find our source code "
        tags.a {href: "https://github.com/rmehlinger/html2reactive"}, "on Github"
        ". © 2015."
      ]
    ]
  ]

init()
