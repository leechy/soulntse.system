@CLASS
users

@auto[]
$iDefaultSessionTime(1/24)
$sSession[$cookie:user_session]
$iLongIP[^ip2long[$env:REMOTE_ADDR]]
$sUserEmail[]
# end @auto

@getCurrentUser[]
^if(def $sSession){
	$fSessions[^hashfile::open[$USER_DIR/sessions]]
	$sUserEmail[$fSessions.$sSessionID]
}{
	^if(def $form:login && def $form:password){
#		^if(-f $USER_DIR/${form:login}.xml){}
	}
}
^if(def $sUserEmail){
	
}
# end @getCurrentUser