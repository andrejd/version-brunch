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
      versionFile: "version.json"
      packageFile: "package.json"
      projectRoot: __dirname + "\\..\\..\\..\\"


    # Merge config
    cfg = @config.plugins?.package ? @config.package ? {}
    @options[k] = cfg[k] for k of cfg


  # Handler executed on compilation
  onCompile: (generatedFiles) ->
    path = @options.projectRoot

    # read or create version file
    try
      version = require(path + @options.versionFile);
    catch e
      console.error(e);
      version =
        version:"0.0.0.0"

    # read package.json file
    try
      pckg = require(path + @options.packageFile).version
    catch e
      console.error(e);

    bld = version.version.split('.')

    # increase build number or reset it if version is different than saved one
    if bld.length == 4 # all data present
      if pckg == bld.slice(0,-1).join('.')
        bld[3] = parseInt(bld[3]) + 1
        version.version = bld.join '.'
      else
        if pckg == "" then pckg = "0.0.0"
        version.version = pckg + '.1'
    else
      console.error "Error: version.json file is corrupted! After deletion it will be recreated!"

    # save version to file
    fs.writeFileSync path + @options.versionFile, JSON.stringify(version)


    return

module.exports = VersionBrunch
