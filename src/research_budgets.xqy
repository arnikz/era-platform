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

let $cols := ('funding-framework', 'isn-call', 'call-id', 'acronym', 'eur-budget-granted', 'eur-requested-budget')
let $header := string-join($cols, $sep) || $nl
let $results := for $partnership in doc("/db/era-platform/era-platform.xml")/partnership-set/partnership
                    let $funding_framework := local:ifNoNode($partnership/funding-framework)
                    for $call in $partnership/platformcall
                        let $call_id := local:ifNoNode($call/call-id)                   
                        for $research in $call/research
                            let $isn_call := local:ifNoNode($research/isn-call)
                            let $acronym := local:ifNoNode($research/acronym)
                            let $eur_budget_granted := local:ifNoNode($research/eur-budget-granted)
                            let $eur_requested_budget := local:ifNoNode($research/eur-requested-budget)
                            let $cols := ($funding_framework, $isn_call, $call_id, $acronym, $eur_budget_granted, $eur_requested_budget)
                    
                            order by $isn_call
                            return string-join($cols, $sep) || $nl

for $line at $i in distinct-values($results)
    return if ($i = 1) then ($header || $line) else $line

