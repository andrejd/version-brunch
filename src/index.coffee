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
    path = __dirname + "\\..\\..\\..\\"
    # read or create version file
    try
      version = require(path + this.options.versionFile);
    catch e
      version =
        version:"0:0:0:0"

      if e.code === 'MODULE_NOT_FOUND'
          fs.writeFileSync path + this.options.versionFile, JSON.stringify(version)
      else
        console.log(e);

    build = version.version.split '.'
    console.log build.length

    # read package.json file
    try
      pckg = require path + this.options.packageFile
      console.log pckg.version
    catch e
      if e.code === 'MODULE_NOT_FOUND'
        # package file not found ... just increment build
      else
        console.log("[version-brunch ERROR] " + e);








    return

module.exports = VersionBrunch
