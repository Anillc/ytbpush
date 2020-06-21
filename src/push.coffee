ytbdl = require 'youtube-dl'
ffmpeg = require 'fluent-ffmpeg'
uuid = (require 'uuid').v4
md5 = require 'blueimp-md5'

mKey = 'key'
pullUrl = 'http://xxx'
pushUrl = 'rtmp://xxx'
ffmpegPath = '/path/to/ffmpeg'

genUrl = (id) ->
  time = (Math.round (new Date).getTime()/1000) + 60 * 60 * 4
  rand = uuid().replace /-/g, ''
  url = "/p/#{id}.flv-#{time}-#{rand}-0-#{mKey}"
  hash = md5 url
  "#{pullUrl}/p/#{id}.flv?auth_key=#{time}-#{rand}-0-#{hash}"

EventEmitter = (require 'events').EventEmitter

module.exports = (url) ->
  emitter = new EventEmitter
  ytbdl.exec url, ['-g','--format=best'], {}, (err, out) ->
    if err then emitter.emit 'error', err
    id = uuid().replace /-/g, ''
    cmd = ffmpeg out[0]
      .setFfmpegPath ffmpegPath
      .videoCodec 'copy'
      .audioCodec 'copy'
      .inputOptions '-re'
      .format 'flv'
      .output "#{pullUrl}/p/#{id}"
      .on 'start', ->
        emitter.id = id
        emitter.url = genUrl id
        emitter.emit 'start', id
      .on 'error', (e) -> emitter.emit 'error', e, id
      .on 'end', -> emitter.emit 'end', id
    emitter.stop = -> cmd.kill()
    cmd.run()
  emitter
