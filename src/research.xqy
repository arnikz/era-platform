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

let $header := string-join(('isn_call', 'acronym', 'status', 'title', 'start_date', 'end_date', 'website', 'role', 'isn_organisation', 'summary'), $sep) || $nl
let $results := for $research in doc("/db/era-platform/era-platform.xml")/partnership-set/partnership/platformcall/research
                    let $acronym := local:ifNoNode($research/acronym)
                    let $isn_call := local:ifNoNode($research/isn-call)
                    let $status := local:ifNoNode($research/status)
                    let $title := local:ifNoNode($research/title)
                    let $start_date := local:ifNoNode($research/start-date)
                    let $end_date := local:ifNoNode($research/end-date)
                    let $website := local:ifNoNode($research/website)
                    let $summary := local:ifNoNode($research/summary)
                    for $participant in $research/participant (: TODO: $research/associates to be resolved :)
                        (: Note: 104 SysMetEX with duplicate isn_organisation=1214 :)
                        let $isn_organisation := local:ifNoNode($participant/isn-organisation)
                        let $role := local:ifNoNode($participant/role)
                        let $cols := ($isn_call, $acronym, $status, $title, $start_date, $end_date, $website, $role, $isn_organisation, $summary)
                        order by $isn_call
                        return string-join($cols, $sep) || $nl

for $line at $i in distinct-values($results)
    return if ($i = 1) then ($header || $line) else $line

