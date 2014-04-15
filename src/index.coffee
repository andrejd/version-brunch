module.exports = class Version
  brunchPlugin: yes

  constructor: (@config) ->

    # Defaults options
    @options = {
      file: 'version'
      ignore: /[\\/][.]/
    }

    # Merge config
    cfg = @config.plugins?.version ? {}
    @options[k] = cfg[k] for k of cfg

  onCompile: ->
