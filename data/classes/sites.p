@CLASS
sites

@auto[]
$xSites[^xdoc::load[${MAIN:DATA_DIR}/sites.xml]]   ^rem{<!-- Файл с XML для всех сайтов -->}
$iStatus(200)                                      ^rem{<!-- Статус страницы, который будет отдаваться клиенту (в т.ч. если есть ошибка) -->}
$sCurrentSiteUrl[]                                 ^rem{<!-- Адрес (протокол + хост + порт + путь) текущего сайта -->}
$sCurrentUri[]                                     ^rem{<!-- uri, который остался после того, как убрали путь к сайту -->}
$nCurrentSite[]                                    ^rem{<!-- xmlNode в которой написано все про сайт -->}
$sRedirectUrl[]                                    ^rem{<!-- Адрес для редиректа -->}
$sPagesPath[]                                      ^rem{<!-- Путь к страницам текущего сайта от htdocs/www -->}
$sFilesUrl[]                                       ^rem{<!-- Адрес, который нужно использовать как префикс для файлов сайта -->}
#end @auto[]


@getCurrentSite[sRequestUrl][nRedirect;nAlias;sUrl]
<!-- Достаем изначальные значения для $sCurrentSiteUrl и $nCurrentSite -->
^getSite[sRequestUrl]

^rem{<!-- Редирект ли это? Если да - сразу редиректим, ничего больше не делая -->}
$nRedirect[^nCurrentSite.selectSingle[redirect]]
^if($nRedirect){
	$sRedirectUrl[^nRedirect.getAttribute[site]]
	$iStatus(301)
	^if(^nRedirect.hasAttribute[uri] && ^nRedirect.getAttribute[uri] eq 'keep'){
		$sRedirectUrl[${sRedirectUrl}$sCurrentUri]
		$response:location[http:$sRedirectUrl]
	}{
		$response:location[http:$sRedirectUrl]
	}
}

^rem{<!-- Если это не редирект, то это может быть алиас -->}
$nAlias[^nCurrentSite.selectSingle[alias]]
^if($nAlias){
	$sUrl[$sCurrentSiteUrl]
	$sSiteAlias[^nAlias.getAttribute[site]]
	<!-- Достаем все данные для сайта, на котором ссылаемся -->
	^getSite[${sSiteAlias}$sCurrentUri]
	<!-- кроме адреса самого сайта -->
	$sCurrentSiteUrl[$sUrl]
}

^rem{<!-- Возвращаем нужные значения для _page.html -->}
$result[
	$.sCurrentSiteUrl[$sCurrentSiteUrl]
	$.iStatus($iStatus)
	$.sCurrentUri[$sCurrentUri]
]
#end @getCurrentSite[]


@getSite[sRequestUrl][nlMatchedSites;nSite;sUrl]
^rem{<!-- Достаем все сайты, чьи пути совпадают с переданным -->}
$nlMatchedSites[^xSites.select[/sites/site[starts-with("$sRequestUrl", @url)]]]

^rem{<!-- Так как совпавшие сайты могут быть несколько - достаем с самым длинным урлом -->}
^nlMatchedSites.foreach(i;nSite){
	$sUrl[^nSite.getAttribute[url]]
	^if(^sUrl.length[] > ^sCurrentSiteUrl.length[]){
		$sCurrentSiteUrl[$sUrl]
		$nCurrentSite[$nSite]
	}
}

^rem{<!-- Если нашли сайт, и адрес сайта содержит кроме хоста, еще и путь, то нужно достать "настоящий" uri -->}
^if(def $sCurrentSiteUrl){
	$sCurrentUri[^sRequestUrl.right(^sRequestUrl.length[] - ^sCurrentSiteUrl.length[])]
}

^rem{<!-- Если ни один сайт не найден, то нужно выдать сайт по-умолчанию (первый) -->}
^if(!def $sCurrentSiteUrl){
	$nCurrentSite[^xSites.selectSingle[/sites/site[@default][1]]]
	$sCurrentSiteUrl[^nCurrentSite.getAttribute[url]]
	$sCurrentUri[$form:req]
}
#end @getSite[]