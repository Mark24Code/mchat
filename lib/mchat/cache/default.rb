module Default
  def default_help_doc
    _puts %Q(
         #{"Help: Default Mode".style.bold}
if you have joined `channel`
and you have a `name` in channel

you can send message without /m  command, that's default mode.

)
  end

  def def default_command_run(words)
    if _current_channel && _current_nickname
      command_message(words)
    else
      _puts "Oops.. This is `Default Mode`:".style.warn
      _puts "if you join channel and have name, it will send message.".style.warn
      _puts "Do nothing. maybe you need join channel or use commands. try /h for more.".style.warn
    end
  end
end
