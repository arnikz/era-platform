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

let $cols := ('country', 'network')
let $header := string-join($cols, $sep) || $nl
let $results := for $partnership in doc("/db/era-platform/era-platform.xml")/partnership-set/partnership
                    let $acronym := local:ifNoNode($partnership/acronym)
                    for $participant in $partnership/participant
                        for $organisation in $participant/organisation
                            let $country := local:ifNoNode($organisation/country)
                            let $cols := ($country, $acronym)
                            (:where $country = ('Austria', 'Italy', 'Belgium',
                                'Latvia', 'Bulgaria', 'Lithuania', 'Croatia',
                                'Luxembourg', 'Cyprus',	'Malta', 'Czech Republic',
                                'Netherlands', 'Denmark', 'Poland', 'Estonia',
                                'Portugal', 'Finland', 'Romania', 'France',
                                'Slovakia', 'Germany', 'Slovenia', 'Greece',
                                'Spain', 'Hungary',	'Sweden', 'Ireland',
                                'United Kingdom', 'Norway', 'Switzerland'):)

                            order by $acronym, $country
                            return string-join($cols, $sep) || $nl
                            
for $line at $i in distinct-values($results)
    return if ($i = 1) then ($header || $line) else $line
