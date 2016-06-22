path    = require 'path'
fs      = require 'fs'
filter  = require 'filter-files'

###
  A short plugin which counts compilations for each package version and stores it into version.json file.
###
class VersionBrunch

  brunchPlugin: yes

  constructor: (@config) ->

    if 'package' of @config
      console.warn 'Warning: config.package is deprecated, please move it to config.plugins.package'

    # Defaults options
    @options =
      versionFile: "version.json"
      fileRegExp: /(app\.js|index\.html)$/

    # Merge config
    cfg = @config.plugins?.version ? @config.version ? {}
    @options[k] = cfg[k] for k of cfg

  generateDefaultMap: (versionExt)->
    map = {}
    # 1.1.1.1 (major.minor.maintenance.build)
    map["{!version!}"]     = parseInt versionExt;
    map["{!major!}"]       = parseInt versionExt.split('.')[0];
    map["{!minor!}"]       = parseInt versionExt.split('.')[1];
    map["{!maintenance!}"] = parseInt versionExt.split('.')[2];
    map["{!build!}"]       = parseInt versionExt.split('.')[3];
    map

  # Handler executed on compilation
  onCompile: (generatedFiles) ->
    # read or create version file
    try
      version = JSON.parse fs.readFileSync path.join(@config.paths.public, @options.versionFile), "utf-8"
    catch e
      version =
        versionExt:"0.0.0.0"

    # read package.json file
    try
      pckg = JSON.parse fs.readFileSync path.join(@config.paths.root, 'package.json'), "utf-8"
    catch e
      pckg =
        version:"0.0.0"

    unless version.versionExt? then version.versionExt = "0.0.0.0"

    bld = version.versionExt.split '.'

    # if version file is the same as package file, work with package file
    if 'package.json' == @options.versionFile then version = pckg

    # increase build number or reset it if version is different than saved one
    if bld.length == 4 # all data present

      if pckg.version == bld.slice(0, -1).join '.'
        bld[3] = parseInt(bld[3]) + 1
        version.versionExt = bld.join '.'
      else
        version.versionExt = pckg.version + '.1'

    else
      console.error "Error: #{@options.versionFile} file is corrupted! After deletion it will be recreated!"

    # save version to file, pretty print
    fs.writeFileSync path.join(@config.paths.public, @options.versionFile), JSON.stringify version, undefined, 2

    map = @generateDefaultMap version.versionExt

    # find files;
    publicFiles = filter.sync @config.paths.public, true

    for f in publicFiles
      continue unless @options.fileRegExp.test f

      fileContent = fs.readFileSync f, "utf-8"
      if fileContent
        resultContent = fileContent
        for keyword, val of map
          keywordRE = RegExp keyword, "g"
          resultContent = resultContent.replace keywordRE, val
        # write back
        fs.writeFileSync f, resultContent, "utf-8"
    return

module.exports = VersionBrunch
