App.EmClipboardComponent = Em.Component.extend
  label: "Copy to clipboard"
  didInsertElement: ->
    client = new ZeroClipboard @$('button')
    client.on "ready", ( readyEvent ) ->
      client.on "aftercopy", (event) ->
        Flash.NM.push 'URL copied to clipboard', "success"
