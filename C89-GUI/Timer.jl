#!/usr/bin/env julia
using Gtk
using Gtk.ShortNames
using WAV

import Base.start
import Gtk.stop

## GUI 以外の情報
type MyTimer
  timer :: Timer
  finish_time :: Float64
  remain_time :: Float64
  sound_filename :: AbstractString
end
const t = MyTimer(Timer(identity, 0, 0), 0.0, 0.0, "default.wav")
const font_size = 60

## ウィジェット
### ウィンドウ本体
const win = @Window("タイマー")
const vbox = @Box(:v)

### メニュー
const menu_bar = @MenuBar()
const file = @MenuItem("ファイル")
const filemenu = @Menu(file)
const menu_open = @MenuItem("音声ファイルの選択")
const menu_quit = @MenuItem("終了")

### タイマー表示部
const timer_label = @Label("""<span font="$font_size">00:00</span>""")
setproperty!(timer_label, :use_markup, true)

### 時間設定
const hbox_spins = @Box(:h)
const min_frame = @Frame("分")
const min_spin = @SpinButton(0, 99, 1)
const sec_frame = @Frame("秒")
const sec_spin = @SpinButton(0, 59, 1)

### スイッチ関係
const hbox_buttons = @Box(:h)
const start_button = @Button("開始")
const finish_button = @Button("停止")
setproperty!(finish_button, :sensitive, false)
const sound_frame = @Frame("音")
const sound_switch = Gtk.@GtkSwitch()

## レイアウト
push!(win, vbox)

push!(vbox, menu_bar)
push!(menu_bar, file)
push!(filemenu, menu_open)
push!(filemenu, menu_quit)

push!(vbox, timer_label)

push!(vbox, hbox_spins)
hbox_spins |> min_frame |> sec_frame
push!(min_frame, min_spin)
push!(sec_frame, sec_spin)

push!(vbox, hbox_buttons)
hbox_buttons |> start_button |> finish_button |> sound_frame
push!(sound_frame, sound_switch)

## 大きさの固定
setproperty!(win, :resizable, false)
setproperty!(min_frame, :expand, true)
setproperty!(sec_frame, :expand, true)
setproperty!(min_spin, :expand, true)
setproperty!(sec_spin, :expand, true)
setproperty!(start_button, :expand, true)
setproperty!(finish_button, :expand, true)
setproperty!(sound_frame, :expand, true)
setproperty!(sound_switch, :expand, true)

## ウィンドウ表示
showall(win)

## タイマー本体
function impl_timer(tm)
  t.remain_time = max(t.finish_time - time(), 0.0)
  if t.remain_time == 0.0
    close(tm)
    finish()
    if( ispath(t.sound_filename) && 
        getproperty(sound_switch, :active, Bool) )
      ### WAV ファイルを鳴らす
      WAV.wavplay(t.sound_filename)
    end
    info_dialog("時間になりました", win)
  end
  show_remain()
  return nothing
end

## 残り時間表示
function show_remain()
  n_remain = ceil(Int, t.remain_time)
  min_remain = div(n_remain, 60)
  sec_remain = n_remain%60
  l = @sprintf("%02d:%02d", min_remain, sec_remain)
  setproperty!(timer_label, :label, """<span font="$font_size">$l</span>""")
  return nothing
end

## 残り時間をリセット
function reset_remain()
  min = getproperty(min_spin, :value, Int)
  sec = getproperty(sec_spin, :value, Int)
  t.remain_time = 60.0min+sec
  show_remain()
  return nothing
end

function start()
  t.finish_time = time() + t.remain_time
  resume()
  return nothing
end

function resume()
  show_remain()
  t.timer = Timer(impl_timer, 0, 0.5)
  setproperty!(start_button, :label, "中断")
  setproperty!(finish_button, :sensitive, true)
  setproperty!(min_spin, :sensitive, false)
  setproperty!(sec_spin, :sensitive, false)
  return nothing
end

function stop()
  t.remain_time = t.finish_time - time()
  close(t.timer)
  setproperty!(start_button, :label, "再開")
  setproperty!(finish_button, :sensitive, true)
  return nothing
end

function finish()
  close(t.timer)
  reset_remain()
  setproperty!(start_button, :label, "開始")
  setproperty!(finish_button, :sensitive, false)
  setproperty!(min_spin, :sensitive, true)
  setproperty!(sec_spin, :sensitive, true)
  return nothing
end


## シグナルリスナー設定

### 簡易版
### 内部でなんらかのロックをかけている様子
### GUI 部分に直接なにかをするわけじゃないならこれでよい
signal_connect(menu_quit, :activate) do w
  if !isinteractive()
    Gtk.gtk_quit()
  else
    exit()
  end
end

function impl_open_menu(ptr, user_data)
  ## ダイアログの親に裏でなにかやると死ぬので止めておく
  running = getproperty(start_button, :label, UTF8String) == "中断"
  if running
    stop()
  end

  ## ファイル選択ダイアログ
  ## フルパスが文字列として返ってくる
  t.sound_filename = open_dialog("アラーム音声を選択", win, ("*.wav",))
  if running
    resume()
  end
  return nothing
end
### 詳細版 
### GUI 部分になにかをするならこちら
signal_connect(impl_open_menu, menu_open, :activate, Void, (), false)

impl_spin(ptr, user_data) = reset_remain()
signal_connect(impl_spin, min_spin, :value_changed, Void, (), false)
signal_connect(impl_spin, sec_spin, :value_changed, Void, (), false)
signal_connect(impl_spin, min_spin, :activate, Void, (), false)
signal_connect(impl_spin, sec_spin, :activate, Void, (), false)

function impl_start_button(ptr, use_data)
  if getproperty(start_button, :label, UTF8String) == "中断"
    stop()
  else
    start()
  end
  return nothing
end
signal_connect(impl_start_button, start_button, :clicked, Void, (), false)

impl_finish_button(ptr, user_data) = finish()
signal_connect(impl_finish_button, finish_button, :clicked, Void, (), false)

## スクリプトモード
if !isinteractive()
  signal_connect(win, :destroy) do w
    Gtk.gtk_quit()
  end
  ### メインループ
  Gtk.gtk_main()
end
