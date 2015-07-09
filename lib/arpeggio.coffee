{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

module.exports = Arpeggio =

  subscriptions: null

  chords: null

  matchChords: (historyString) ->
    maxChordLength = Math.max((key.length for key of @chords)...)
    for i in [Math.min(historyString.length, maxChordLength)..2] by -1
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
        key = _.sortBy(_.uniq(_.toArray(key))).join('')
        mapping[key] = expansion
    @chords = mapping

  enableChords: (editor) ->
    view = atom.views.getView(editor)
    history = []
    onKeyPress = (event) =>
      if event.charCode
        history.push
          char: String.fromCharCode(event.charCode)
          keyIdentifier: event.keyIdentifier
          timeStamp: event.timeStamp
      else
        history.length = 0

    onKeyUp = (event) =>
      historyString = (char for { char } in history).join('')
      match = @matchChords(historyString)
      if match
        history.length = 0
        console.log('Match.length is ', match)
        editor.selectLeft(match.length)
        editor.insertText('', undo: 'skip')
        @trigger(editor, view, match.expansion)
      history = history.filter ({ keyIdentifier }) -> keyIdentifier isnt event.keyIdentifier
    view.addEventListener 'keypress', onKeyPress
    view.addEventListener 'keyup', onKeyUp
    @subscriptions.add
      dispose: ->
        view.removeEventListener 'keypress', onKeyPress
        view.removeEventListener 'keyup', onKeyUp

  trigger: (editor, view, expansion) ->
    if typeof expansion is 'string'
      editor.insertText(expansion)
    else if expansion and typeof expansion is 'object'
      if expansion.command
        atom.commands.dispatch(view, expansion.command)
      if expansion.snippet
        snippets = atom.packages.getActivePackage('snippets').mainModule
        snippets.insert(expansion.snippet)

  deactivate: ->
    @subscriptions.dispose()
