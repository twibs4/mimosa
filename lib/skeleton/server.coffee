express =        require 'express'
reloadOnChange = require 'watch-connect'
gzip =           require 'gzippo'

routes  =        require './routes'

exports.startServer = (publicPath, useReload, optimize) ->

  app = express()
  server = app.listen 3000, ->
     console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  app.configure ->
    app.set 'port', process.env.PORT || 3000
    app.set 'views', "#{__dirname}/views"
    app.set 'view engine', 'jade'
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use reloadOnChange(publicPath, server, {verbose: false, skipAdding:true}) if useReload
    app.use app.router
    app.use gzip.staticGzip(publicPath)

  app.configure 'development', ->
    app.use express.errorHandler()

  app.configure 'production', ->
    app.use express.errorHandler()
    app.use gzip.gzip()

  app.get '/', routes.index(useReload, optimize)


