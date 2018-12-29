-- FaceTimeCallerID V0.2
-- 
-- Collavr Inc. 2015
-- MIT License
-- https://github.com/collavr/FaceTimeCallerInfo

tell application "System Events"
	local lastPhoneNumber
	repeat
		try
			if exists (process "通知中心") then
				set theProcess to process "通知中心"
				if exists (windows of theProcess) then
					set theWindows to (windows of theProcess)
					repeat with theWindow in theWindows
						set nameOfTheWindow to (name of theWindow) as text
						if nameOfTheWindow is equal to "missing value" or nameOfTheWindow is equal to "" then
							set theContents to (entire contents of theWindow)
							repeat with theContent in theContents
								set classOfTheContent to (class of theContent) as text
								if (class of theContent) is equal to (static text) or (class of theContent) as text is equal to "static text" then
									set nameOfTheContent to (name of theContent) as text
									set phoneNumber to (do shell script "echo " & nameOfTheContent & " | grep -o [0-9] | xargs echo | sed 's/ //g'") as text
									if phoneNumber is not equal to "" then
										if phoneNumber is not equal to lastPhoneNumber then
											set lastPhoneNumber to phoneNumber
											set result to (do shell script "curl \"https://open.onebox.so.com/dataApi?query=" & phoneNumber & "&url=mobilecheck&type=mobilecheck&src=onebox\" | /usr/local/bin/jq '.data.countDesc' | textutil -stdin -stdout -format html -convert txt -inputencoding UTF-8 -encoding UTF-8 | grep -v null")
											if result is not equal to "" then
												display notification result
											end if
										end if
									end if
								end if
							end repeat
						else
							set lastPhoneNumber to (missing value)
						end if
					end repeat
				else
					set lastPhoneNumber to (missing value)
				end if
			else
				set lastPhoneNumber to (missing value)
			end if
		end try
		
		delay 1
	end repeat
end tell
