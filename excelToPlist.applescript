tell application "System Events"
	-- Create an empty property list dictionary item
	set theParentDictionary to make new property list item with properties {kind:record}
	
	-- Create a new property list file using the empty dictionary list item as contents
	set thePropertyListFilePath to "~/Desktop/myPlist.plist"
	
	set thePropertyListFile to make new property list file with properties {contents:theParentDictionary, name:thePropertyListFilePath}
	
	-- Add a Boolean key
	tell property list items of thePropertyListFile
		-- Add a string key
		make new property list item at end with properties {kind:string, name:"stringKey", value:"string value TEST"}
	end tell
end tell

tell application "Microsoft Excel"
	tell document 1
		tell worksheet "Sheet1" of active workbook
			set myValues to value of used range
		end tell
	end tell
end tell

repeat with each in myValues
	set theValue to item 1 of each
	set theKey to item 2 of each
	tell application "System Events"
		-- Add a Boolean key
		tell property list items of thePropertyListFile
			-- Add a string key
			make new property list item at end with properties {kind:string, name:theKey, value:theValue}
		end tell
	end tell
end repeat
