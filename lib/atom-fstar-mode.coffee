AtomFstarModeView = require './atom-fstar-mode-view'
{CompositeDisposable} = require 'atom'

{BufferedProcess} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = AtomFstarMode =
  atomFstarModeView: null
  modalPanel: null
  subscriptions: null
  config: configSchema

  run:  ->
    command = atom.config.get('atom-fstar-mode.fstarExe')
    console.log(command)
    args = ['~/home/ash/Dev/FST/Graph.fst']
    bp = new BufferedProcess({command, args})
    console.log('hello')

  activate: (state) ->
    @atomFstarModeView = new AtomFstarModeView(state.atomFstarModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomFstarModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-fstar-mode:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomFstarModeView.destroy()

  serialize: ->
    atomFstarModeViewState: @atomFstarModeView.serialize()

  toggle: ->
    console.log 'AtomFstarMode was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @run()
