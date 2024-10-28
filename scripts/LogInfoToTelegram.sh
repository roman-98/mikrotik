:global lastTime;
:global output;
:global ChatId;
:global TelegramApi;
:set TelegramApi token
:set ChatId chatid
:global mtIdentity [/system identity get name];

:local logEntries [ :toarray [ /log find ] ];
:local logLineCount [ :len $logEntries ];

if ($logLineCount > 0) do={
    :local currentTime "$[ /log get [ :pick $logEntries ($logLineCount - 1) ] time ]";
    :if ([:len $currentTime] = 10) do={
        :set currentTime [ :pick $currentTime 0 10 ];
    }
    
    :local logMessage $[/log get [ :pick $logEntries ($logLineCount - 1) ] message];
    :local logType $[/log get [ :pick $logEntries ($logLineCount - 1) ] topics];

    :if (($logType = "critical") || 
        ($logType = "l2tp") ||
        ($logType = "ipsec") || 
        ($logType = "system") || 
        ($logType = "info") || 
        ($logType = "account") || 
        ($logType = "dhcp")) do={

        :set output "$currentTime - $logMessage";
        
        :if (([:len $lastTime] < 1) || (([:len $lastTime] > 0) && ($lastTime != $currentTime))) do={
            :set lastTime $currentTime;
            :tool fetch url=("https://api.telegram.org/bot$TelegramApi/sendMessage?chat_id=$ChatId&text=%F0%9F%93%A1\"$mtIdentity\" :  $output") keep-result=no;
        }
    }
}