path = require 'path'
fs  = require 'fs'

###
  A short plugin which counts compilations for each package version and stores it into version.json file.
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
    cfg = @config.plugins?.version ? @config.version ? {}
    @options[k] = cfg[k] for k of cfg


  # Handler executed on compilation
  onCompile: (generatedFiles) ->

    # read or create version file
    try
      version = require @options.projectRoot + @options.versionFile
    catch e
      version =
        versionExt:"0.0.0.0"

    # read package.json file
    try
      pckg = require @options.projectRoot + @options.packageFile
    catch e
      pckg =
        version:"0.0.0"

    unless version.versionExt? then version.versionExt = "0.0.0.0"
    bld = version.versionExt.split '.'

    # if version file is the same as package file, work with package file
    if @options.packageFile == @options.versionFile
      version = pckg

    # increase build number or reset it if version is different than saved one
    if bld.length == 4 # all data present

      if pckg.version == bld.slice(0, -1).join '.'
        bld[3] = parseInt(bld[3]) + 1
        version.versionExt = bld.join '.'
      else
        version.versionExt = pckg.version + '.1'

    else
      console.error "Error: #{@options.packageFile} file is corrupted! After deletion it will be recreated!"

    # save version to file, prety print
    fs.writeFileSync @options.projectRoot + @options.versionFile, JSON.stringify version, undefined, 2

    return

module.exports = VersionBrunch
