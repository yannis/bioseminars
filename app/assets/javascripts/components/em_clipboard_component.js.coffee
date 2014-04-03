App.EmClipboardComponent = Em.Component.extend
  label: "Copy to clipboard"
  didInsertElement: ->
    clip = new ZeroClipboard @$('button'),
      # This would normally be a relative path
      moviePath: "ZeroClipboard.swf"

      # Added for demo on JSFiddle. See http://goo.gl/DLl7O
      trustedDomains: ["*"]
      allowScriptAccess: "always"

    clip.on 'complete', (client, args) ->
      Flash.NM.push 'URL copied to clipboard', "success"
