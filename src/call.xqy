xquery version "3.0";
declare option exist:serialize "method=text media-type=text/plain";
declare variable $nl := "&#010;";
declare variable $tab := "&#009;";
declare variable $sp := "&#032;";
declare variable $sep := '|';
declare function local:ifNoNode($p)
{
    let $rv := if (exists($p)) then $p/string() else ''
    return $rv
};

let $header := string-join(('isn_call','call_id','year','isn_era'), $sep) || $nl
let $results := for $call in doc("/db/era-platform/era-platform.xml")/partnership-set/partnership/platformcall
                    let $year := local:ifNoNode($call/year)
                    let $call_id := local:ifNoNode($call/call-id)
                    for $isn_era in $call/isn-eranet
                        let $isn_call := local:ifNoNode($call/@isn)
                        let $cols := ($isn_call, $call_id, $year, $isn_era)
                        order by $isn_call
                        return string-join($cols, $sep) || $nl

for $line at $i in distinct-values($results)
    return if ($i = 1) then ($header || $line) else $line
