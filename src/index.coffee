{ App, CQCode } = require 'koishi'
push = require './push'

app = new App
  type: 'ws'
  server: 'ws://xxx'
  commandPrefix: '|'

app.start()

ctx = app
  .user 1684734774
  .plus app.groups

checkUser = (meta)->
  if meta.postType != 'message' then false
  if !(meta.sender.role? and (meta.sender.role == 'admin' or meta.sender.role == 'owmer'))
    meta.$send '只有管理员才让用哦www'
    false
  true

ps = new Map()

ctx.command '转播 <url...>'
  .action ({meta}, url) ->
    if !checkUser meta then return
    p = push url
    p.on 'start', (id) ->
      ps.set id, p
      meta.$send "id: #{id}\nurl: #{p.url}"
    p.on 'end', (id) ->
      ps.delete id
      meta.$send "id: #{id} 转播结束"
    p.on 'error', (err, id) ->
      ps.delete id
      meta.$send "id: #{id}\nerr: #{err}"

ctx.command '关闭转播 <id...>'
  .action ({meta}, id) ->
    if !checkUser meta then return
    p = ps.get id
    if !p
      meta.$send '该id不存在www'
      return
    p.stop()
    ps.delete id

ctx.command '列表'
  .action ({meta}) ->
    if ps.size == 0
      meta.$send '当前没有正在转播的视频/直播哦'
      return
    s = ''
    ps.forEach (each) ->
      s += "#{each.id}: #{each.url}\n"
    meta.$send s.trim()
