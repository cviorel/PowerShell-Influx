﻿Function Send-Statsd {
    <#
        .SYNOPSIS
            Send metrics to a statsd server via UDP.

        .DESCRIPTION
            PowerShell cmdlet to send metric data to a statsd server. Unless server or port is passed, uses the default 127.0.0.1 and port of 8125.
    
        .PARAMETER Data
            Metric data to send to statsd.  If string is not enclosed in quotes (single or double), the pipe character needs to be escaped.
    
        .PARAMETER IP
            IP address for statsd server
    
        .PARAMETER Port
            Port that statsd server is listening to
    
        .EXAMPLE
            Send-Statsd 'my_metric:123|g'

        .EXAMPLE
            Send-Statsd 'my_metric:321|g' -ip 10.0.0.10 -port 8180

        .EXAMPLE
            'my_metric:1|c' | Send-Statsd
    #>
    [cmdletbinding(SupportsShouldProcess,ConfirmImpact='Medium')]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]
        $Data,

        [ipaddress]
        $IP = '127.0.0.1',
  
        [int]
        $Port = 8125
    )

    Process {
        ForEach ($Item in $Data) {
            
            if ($PSCmdlet.ShouldProcess("$($IP):$Port","$($MyInvocation.MyCommand) -Data $Item")) {
                $Item | Invoke-UDPSendMethod -IP $IP -Port $Port
            }
        }
    } 
}