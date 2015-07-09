Arpeggio = require '../lib/arpeggio'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Arpeggio", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('arpeggio')

  describe "when configuration is loaded", ->
    it "matches the text", ->
      Arpeggio.loadConfig 'fnu': 'function'
      expect(Arpeggio.matchChords('ZNUF').expansion).toEqual('function')
