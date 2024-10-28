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
    :foreach logId in=$logEntries do={
        :local logMessage $[/log get $logId message];
        :local logTime $[/log get $logId time];
        :local logType $[/log get $logId topics]; 
        
        :if (($lastLogId < $logId) && 
            (($logType = "critical") || 
             ($logType = "l2tp") ||
             ($logType = "ipsec") ||  
             ($logType = "system") || 
             ($logType = "info") || 
             ($logType = "account") || 
             ($logType = "dhcp"))) do={
             
            :set output "$logTime - $logMessage";
            :set lastLogId $logId;
            
            :tool fetch url=("https://api.telegram.org/bot$TelegramApi/sendMessage?chat_id=$ChatId&text=%F0%9F%93%A1\"$mtIdentity\" :  $output") keep-result=no;
        }
    }
}