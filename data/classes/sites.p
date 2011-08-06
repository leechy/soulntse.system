@CLASS
sites

@auto[]
$xSites[^xdoc::load[${MAIN:DATA_DIR}/sites.xml]]   ^rem{<!-- Файл с XML для всех сайтов -->}
$iStatus(200)                                      ^rem{<!-- Статус страницы, который будет отдаваться клиенту (в т.ч. если есть ошибка) -->}
$sSiteUrl[]                                        ^rem{<!-- Адрес (протокол + хост + порт + путь) текущего сайта -->}
$sPagesPath[]                                      ^rem{<!-- Путь к страницам текущего сайта от htdocs/www -->}
$sFilesUrl[]                                       ^rem{<!-- Адрес, который нужно использовать как префикс для файлов сайта -->}


@getSite[sRequestUrl]
^rem{<!-- Достаем все сайты, чьи пути совпадают с переданным -->}
$nlMatchedSites[^xSites.select[/sites/site[starts-with("$sRequestUrl", @url)]]]

^throw[sites;sRequestUrl;^nlMatchedSites.foreach(i;k){
<$k.nodeName ^k.attributes.foreach(l;m){$m.nodeName="$m.nodeValue"}>
</$k.nodeName>
}]