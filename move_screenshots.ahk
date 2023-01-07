; ==================================================================================================================================
; Function:       Move screenshots taken with the Windows clipping tool (Win + Shift + S) to a more user friendly path.
; Author:         Daniel Garcia -> https://github.com/uxDaniel
; ==================================================================================================================================


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.

; Set the path to the source folder
screenshotsFolder := "C:\Users\" A_UserName "\AppData\Local\Packages\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TempState\ScreenClip"

; Set the path to the destination folder for large screenshots
largeScreenshotsFolder := "C:\Users\" A_UserName  "\Pictures\Screenshots"

; Create a FileSystemObject to access the file system
FileSystemObject := ComObjCreate("Scripting.FileSystemObject")

; Create a loop to check the source folder every 5 seconds
Loop
{
    ; Get a list of all files in the source folder
    files := FileSystemObject.GetFolder(screenshotsFolder).Files

    ; Check if the destination folder exists
    if !FileSystemObject.FolderExists(largeScreenshotsFolder)
    {
        ; If the destination folder does not exist, create it
        FileSystemObject.CreateFolder(largeScreenshotsFolder)
    }
    
    ; Iterate through each file in the folder
    for file in files
    {
        ; Get the file's extension
        extension := FileSystemObject.GetExtensionName(file)

        ; Check if the file is a PNG file
        if (extension = "png")
        {
            ; If the file is a PNG file, get its creation date
            creationDate := FileSystemObject.GetFile(file).DateCreated

            ; Format the creation date as a string in the format "YYYY-MM-DD_HH-MM-SS"
            dateStr := creationDate.Year . "-" . creationDate.Month . "-" . creationDate.Day . "_" . creationDate.Hour . "-" . creationDate.Minute . "-" . creationDate.Second

            ; Construct the new file name using the date string and the ".png" extension
            newFileName := dateStr . ".png"

            ; Get the full path to the destination folder
            destinationPath := FileSystemObject.BuildPath(largeScreenshotsFolder, newFileName)

            ; Check if a file with the same name already exists in the destination folder
            if FileSystemObject.FileExists(destinationPath)
            {
                ; If the file already exists, compare their sizes
                existingFileSize := FileSystemObject.GetFile(destinationPath).Size
                newFileSize := FileSystemObject.GetFile(file).Size

                ; If the new file is larger, delete the existing file and move the new file
                if (newFileSize > existingFileSize)
                {
                    FileSystemObject.DeleteFile(destinationPath)
                    FileSystemObject.MoveFile(file, destinationPath)
                }
                ; If the new file is smaller or the same size, delete the new file
                else
                {
                    FileSystemObject.DeleteFile(file)
                }
            }

            ; If the file does not already exist, move the file to the destination folder
            else
            {
                FileSystemObject.MoveFile(file, destinationPath)
            }
        }
        else
        {
            ; If the file is not a PNG file, delete it
            FileSystemObject.DeleteFile(file)
        }
    }

    ; Sleep for 5 seconds
    Sleep, 5000
}
