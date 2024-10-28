:global lastTime;
:global output;
:global ChatId;
:global TelegramApi;
:set TelegramApi token
:set ChatId chatid
:global mtIdentity [/system identity get name];

:local LogGet [ :toarray [ /log find ]];

:local LogtLineCount [ :len $LogGet ];

if ($LogtLineCount > 0) do={
:local currentTime "$[ /log get [ :pick $LogGet ($LogtLineCount -1) ] time ]";
:if ([:len $currentTime] = 10 ) do={
:set currentTime [ :pick $currentTime 0 10 ];
}
:set output "$currentTime - $[/log get [ :pick $LogGet ($LogtLineCount-1) ] message]";
:if (([:len $lastTime] < 1) || (([:len $lastTime] > 0) && ($lastTime != $currentTime))) do={
:set lastTime $currentTime ;
:tool fetch url=("https://api.telegram.org/bot$TelegramApi/sendmessage\?chat_id=$ChatId&text=%F0%9F%93%A1\"$mtIdentity\" :  $output") keep-result=no 
}

}