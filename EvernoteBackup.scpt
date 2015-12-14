-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Export Evernote Notes to Dropbox
-- forked from https://github.com/jamietr1/evernote-backup
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- get the current date as string for use in settingthe new filename
set currDate to do shell script "date +%Y%m%d"
-- create filename variable
set fname to currDate & ".enex"
--set path to archive
set srcFolder to "Macintosh HD:Users:XXXXXXXX:Dropbox:EverArch" as alias
set fileExp to (srcFolder as string) & fname

--get creation date of most recent save
tell application "Finder"
  sort (get files of folder srcFolder) by creation date
  -- This raises an error if the folder doesn't contain any files
  set theFile to (item 1 of result) as alias
  set fileCreated to creation date of theFile

end tell


set notesFrom to fmtDate(fileCreated)

to fmtDate(inputDate)
  --format the notesFrom date to 19000101 and prepend "created:"
  set y to text -4 thru -1 of ("0000" & (year of inputDate))
  set m to text -2 thru -1 of ("00" & ((month of inputDate) as integer))
  set d to text -2 thru -1 of ("00" & (day of inputDate))
  set newdate to "created:" & y & m & d
  return newdate
end fmtDate

-- have Evernote do the archive
with timeout of (30 * 60) seconds
  tell application "Evernote"
    set matches to find notes notesFrom
    export matches to fileExp
  end tell
end timeout

-- Compress the file so that there is less to backup to the cloud
set p to POSIX path of fileExp
do shell script "/usr/bin/gzip " & quoted form of p
-- PURPOSE: Export all notes in Evernote to an ENEX file so that
-- the notes can be backed up to an external drive or to the cloud

-- Change the path below to the location you want the notes to be exported
set f to "/Volumes/My Book/Data/Backup/Export.enex"

with timeout of (30 * 60) seconds
	tell application "Evernote"
		-- Set date to 1990 so it finds all notes
		set matches to find notes "created:19900101"
		-- export to file set above
		export matches to f
	end tell
end timeout

-- Compress the file so that there is less to backup to the cloud
set p to POSIX path of f
do shell script "/usr/bin/gzip " & quoted form of p
