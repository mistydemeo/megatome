music = document.getElementById("music")
music.status = "play"
pause_button = document.getElementById("pause_button")

pause_button.onclick = ->
	if music.status == "pause"
		music.status = "play"
		music.play()
	else
		music.status = "pause"
		music.pause()

	false