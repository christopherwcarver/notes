<#
auth: Carver, Christopher
desc: Determines if we are inside the time window.
note: To be used by Orchestrator.
#>

<# SUBSCRIBE TO PUBLISHED DATA HERE
   Dev Note: Replace INSERT VARIABLE and INSERT PUBLISHED DATA in the lines
   below from Orchestrator.
-----------------------------------------------------------------------------#>

# start of window time
$startTime = "\`d.T.~Ed/{CF6C6161-C9B7-424C-A5AA-48AF9D06A409}.Power On Time (UTC)\`d.T.~Ed/"
# stop of window time
$stopTime = "\`d.T.~Ed/{CF6C6161-C9B7-424C-A5AA-48AF9D06A409}.Power Off Time (UTC)\`d.T.~Ed/"
# days for the window to be open
$activeDays = "\`d.T.~Ed/{CF6C6161-C9B7-424C-A5AA-48AF9D06A409}.Power On Days\`d.T.~Ed/"

# set return code, information, and trace to defaults
# valid return codes:
#  0 -- Success
#  1 -- Success with info
#  2 -- Error
#  3 -- Fatal Error
# valid return states:
#  SUCCESS -- The execution and operation was successful
#  FAILURE -- The execution or operation failed
$retCode = 0
$retState = "SUCCESS"
$retInfo = ""
$retTrace = ""
$window = ""

<# MAIN
-----------------------------------------------------------------------------#>

$retTrace += "`r`n$(Get-Date -format 'u')`t Entering Determine Inside Time Window."
$retTrace += "`r`n$(Get-Date -format 'u')`t   Parameters:"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Start Time: $startTime"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Stop Time: $stopTime"
$retTrace += "`r`n$(Get-Date -format 'u')`t     Active Days: $activeDays"


$today = (Get-Date).DayOfWeek
$tokens = $activeDays -split ","       
$now=(GET-DATE)
 
$retTrace += "`r`n$(Get-Date -format 'u')`t Checking active days with $today." 
$result = $tokens -contains $today 
if ($result -eq $False) 
{
  $retTrace += "`r`n$(Get-Date -format 'u')`t Today outside of active days."
  $retTrace += "`r`n$(Get-Date -format 'u')`t Returning 'Outside'."
  $window = "Outside" 
}
else 
{
  $retTrace += "`r`n$(Get-Date -format 'u')`t Today is an active day."
  if ([datetime]$startTime -eq [datetime]$stopTime)
  {
    $retTrace += "`r`n$(Get-Date -format 'u')`t The window is 24 hrs today."
    $window = "Inside"
  }
  if( [datetime]$stopTime -gt [datetime]$startTime )
  {
    $retTrace += "`r`n$(Get-Date -format 'u')`t No day overlap in window."
    if (($now -ge [datetime]$startTime) -and ($now -le [datetime]$stopTime))
    { 
      $retTrace += "`r`n$(Get-Date -format 'u')`t We are inside the time window."
      $window = "Inside"
    }
    else 
    {       
      $retTrace += "`r`n$(Get-Date -format 'u')`t We are outside the time window."
      $window = "Outside"
    }
  }
  else 
  {
    $retTrace += "`r`n$(Get-Date -format 'u')`t There is a day overlap in the time window."
    if (($now -ge [datetime]$startTime) -or ($now -le [datetime]$stopTime))
    { 
      $retTrace += "`r`n$(Get-Date -format 'u')`t We are inside the time window."
      $window = "Inside"
    }
    else 
    {       
      $retTrace += "`r`n$(Get-Date -format 'u')`t We are outside the time window."
      $window = "Outside"
    } 
  }
}
