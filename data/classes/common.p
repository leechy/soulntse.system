# Общие методы

##########################
# Преобразование IP адресов
# by redactor (Denis Rastegaev)
# http://www.parser.ru/forum/?id=27859
@ip2long[ip][ip]
$result[^ip.match[(\d+)\.(\d+)\.(\d+)\.(\d+)][g]{^eval($match.1 * ^math:pow(256;3) + $match.2 * ^math:pow(256;2) + $match.3 * 256 + $match.4)[%.0f]}]
#end @ip2long[]

# by Misha v.3 (Michael V. Petrushin)
# http://www.parser.ru/forum/?id=37158
@long2ip[num][d;dd;d1;d2;d3;d4]
$result[]
^if(def $num){
	$d(^num.double[])
	$d1(^math:floor($d / 0x1000000))
	$dd($d % 0x1000000)
	$d2(($dd >> 16) & 0xFF)
	$d3(($dd >> 8) & 0xFF)
	$d4(($dd) & 0xFF)
	$result[${d1}.${d2}.${d3}.$d4]
}
#end @intToIp[]
