{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

module.exports = Arpeggio =

  subscriptions: null

  chords: null

  matchChords: (historyString) ->
    maxChordLength = Math.max((key.length for key of @chords)...)
    for i in [maxChordLength..2] by -1
      key = _.sortBy(historyString.substr(-i)).join('')
      result = @chords[key]
      if result
        return {
          length: i
          expansion: result
        }
    return null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'arpeggio.chords', (chords) =>
      @loadConfig(chords)
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @enableChords(editor)

  loadConfig: (config) ->
    mapping = { }
    if config and typeof config is 'object'
      for own key, expansion of config
        key = _.sortBy(_.uniq(_.toArray(key.toUpperCase()))).join('')
        mapping[key] = expansion
    @chords = mapping

  enableChords: (editor) ->
    view = atom.views.getView(editor)
    history = []
    onKeyDown = (event) =>
      return if event.ctrlKey or event.shiftKey or event.metaKey
      if 65 <= event.keyCode <= 90
        history.push
          char: String.fromCharCode(event.keyCode)
          timeStamp: event.timeStamp
      else
        history.length = 0
      while history.length > 1 and history[0].timeStamp < history[1].timeStamp - 64
        history.shift()
      historyString = (char for { char } in history).join('')
      match = @matchChords(historyString)
      if match
        setTimeout ->
          editor.selectLeft(match.length)
          editor.insertText(match.expansion)
    onKeyUp = (event) =>
      return if event.ctrlKey or event.shiftKey or event.metaKey
      if 65 <= event.keyCode <= 90
        pressedKey = String.fromCharCode(event.keyCode)
        history = history.filter ({ char }) -> char isnt pressedKey
    view.addEventListener 'keydown', onKeyDown
    view.addEventListener 'keyup', onKeyUp
    @subscriptions.add
      dispose: ->
        view.removeEventListener 'keydown', onKeyDown
        view.removeEventListener 'keyup', onKeyUp

  deactivate: ->
    @subscriptions.dispose()
