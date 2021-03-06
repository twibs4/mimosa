"use strict"

fs =   require 'fs'

logger = require 'logmimosa'

fileUtils = require '../../util/file'

class MimosaFileWriteModule

  registration: (config, register) ->

    unless config.isVirgin
      e = config.extensions
      cExts = config.copy.extensions
      register ['add','update','remove','buildExtension'], 'write', @_write, [e.template..., e.css...]
      register ['add','update','buildFile'],               'write', @_write, [e.javascript..., cExts...]

  _write: (config, options, next) =>
    return next() unless options.files?.length > 0

    i = 0
    done = =>
      next() if ++i is options.files.length

    options.files.forEach (file) =>
      return done() if not file.outputFileText or not file.outputFileName
      logger.debug "Writing file [[ #{file.outputFileName} ]]"
      fileUtils.writeFile file.outputFileName, file.outputFileText, (err) =>
        if err?
          logger.error "Failed to write new file [[ #{file.outputFileName} ]], Error: #{err}"
        else
          logger.success "Compiled/copied [[ #{file.outputFileName} ]]", options
        done()

module.exports = new MimosaFileWriteModule()