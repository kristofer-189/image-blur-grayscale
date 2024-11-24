#Requires AutoHotkey v2.0

SetWorkingDir A_ScriptDir
#SingleInstance Force
DetectHiddenWindows True

ImageFile := ""
MainGui()
Return

MainGui(){
	Global
	Main := Gui("", "Image Transform")
	Main.Add("Text", "x10 y10 w600 h25 center", "Upload and Transform Your Image").SetFont("s16 bold")
	Main.Add("Text", "x10 y40 w600 h25", "Choose an image:").SetFont("s10 bold")
	Main.Add("Button", "x10 y70 Default w80", "Browse").OnEvent("Click", SelectImageFile)
	FileSelectText := Main.Add("Text", "x100 y70 w500 h25", "No file selected")
	FileSelectText.SetFont("s10")
	Main.Add("Text", "x10 y100 w600 h25", "Choose an option:").SetFont("s10 bold")
	ImageTrans := Main.Add("DropDownList", "x10 y130 w600", ["Blur", "Grayscale"])
	ConvertButton := Main.Add("Button", "x10 y160 w600 h30", "Upload and Convert")
	ConvertButton.OnEvent("Click", ConvertImage)
	Main.Show()
	Return
}

ResGui(){
	Global
	Res := Gui("", "Image Transform")
	Res.Add("Text", "x10 y10 w800 h25 center", "Original and Transformed Image").SetFont("s16 bold")
	Res.Add("Text", "x10 y70 w390 h25 center", "Original Image").SetFont("s10 bold")
	Res.Add("Text", "x410 y70 w390 h25 center", "Transformed Image").SetFont("s10 bold")
	OriginalImage := Res.Add("Picture", "x10 y100 w390 h-1", ImageFile)
	TransformedImage := Res.Add("Picture", "x410 y100 w390 h-1", "output.png")
	Res.Add("Button", "x365 y40 w80 h30", "Go Back").OnEvent("Click", CloseResult)
	Res.Show()
	Return
}

CloseResult(*){
	Global
	Res.Destroy()
	MainGui()
}

SelectImageFile(*){
	Global
	ImageFile := FileSelect("1", , , "All Pictures (*.jpg;*.jpeg;*.png;")
	FileSelectText.Text := ImageFile
	Return
}

ConvertImage(*){
	Global
	Try FileDelete("output.png")
	If(!ImageFile){
		ShowError("Please select a file!")
		Return
	}
	If(!FileExist(ImageFile)){
		ShowError("File does not exist!")
		Return
	}
	ValidFileExt := ["jpg", "jpeg", "png"]
	FileExt := ""
	FileExtIsValid := False
	SplitPath(ImageFile, , , &FileExt, , )
	For x in ValidFileExt {
		If(x = FileExt){
			FileExtIsValid := True
			Break
		}
	}
	If(!FileExtIsValid){
		ValidFileExtStr := ""
		For x in ValidFileExt
			ValidFileExtStr .= x " "
		ShowError("File extension must be one of: " ValidFileExtStr)
		Return
	}
	If(!ImageTrans.Value){
		ShowError("Please select a transformation option!")
		Return
	}
	ConvertButton.Text := "Transforming..."
	RunWait(A_ComSpec ' /c python transform.py "' ImageFile '" ' ImageTrans.Value, , "Hide")
	If(!FileExist("output.png")){
		ShowError("There was an error transforming your image")
		ConvertButton.Text := "Upload and Convert"
		Return
	}
	Main.Destroy()
	ResGui()
	Return
}

ShowError(Message){
	MsgBox(Message, "Error", "48")
}