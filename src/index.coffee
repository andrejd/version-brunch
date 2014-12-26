path = require 'path'
fs  = require 'fs'

###
  A short plugin in order to add a package.js file with the list of files.
###
class VersionBrunch
  # Tell brunch this is a plugin
  brunchPlugin: yes
  # Plugin constructor to read conf.
  constructor: (@config) ->
    if 'package' of @config
      console.warn 'Warning: config.package is deprecated, please move it to config.plugins.package'

    # Defaults options
    @options =
      fileName: 'package.js'
      fileSource: "package.json"
      nameSpace: "app"
      fileTransform:
        (data)-> return data

    # Merge config
    cfg = @config.plugins?.package ? @config.package ? {}
    @options[k] = cfg[k] for k of cfg


  # Handler executed on compilation
  onCompile: (generatedFiles) ->
    #packageInfos = require("#{__dirname}#{'/../../'}#{@options.fileSource}")
    #filePath = path.join(@config.paths.public,"js", @options.fileName)
    #fileString = "
    #  window.#{@options.nameSpace} = window.#{@options.nameSpace} ||{};
    #  window.#{@options.nameSpace}.package = #{JSON.stringify(@options.fileTransform(packageInfos), null, 2)};
    # "
    # fs.writeFileSync(filePath, fileString);

    return

module.exports = VersionBrunch
