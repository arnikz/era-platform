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

let $cols := ('isn_partnership', 'status', 'partnership_type', 'acronym', 'title', 'start_date', 'end_date', 'website', 'role', 'isn_organisation', 'objective', 'mapping')
let $header := string-join($cols, $sep) || $nl
let $results := for $partnership in doc("/db/era-platform/era-platform.xml")/partnership-set/partnership
                    let $isn_partnership := local:ifNoNode($partnership/@isn)
                    let $partnership_type := local:ifNoNode($partnership/p2p-partnership-type)
                    let $acronym := local:ifNoNode($partnership/acronym)
                    let $status := local:ifNoNode($partnership/status)
                    let $title := local:ifNoNode($partnership/title)
                    let $start_date := local:ifNoNode($partnership/start-date)
                    let $end_date := local:ifNoNode($partnership/end-date)
                    let $website := local:ifNoNode($partnership/website)
                    let $objective := local:ifNoNode($partnership/objective)
                    let $mapping := local:ifNoNode($partnership/mapping)
                    for $participant in $partnership/participant (: TODO: $partnership/observer to be resolved :)
                        let $role := local:ifNoNode($participant/role)
                        let $isn_organisation := local:ifNoNode($participant/isn-organisation)
                        let $cols := ($isn_partnership, $status, $partnership_type, $acronym, $title, $start_date, $end_date, $website, $role, $isn_organisation, $objective, $mapping)
                        order by $isn_partnership
                        return string-join($cols, $sep) || $nl

for $line at $i in $results
    return if ($i = 1) then ($header || $line) else $line
