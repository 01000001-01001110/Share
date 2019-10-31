<# 
SHARP BOT This script will make you regret running it. 
Run script, it runs for one minute, during which it will verbally attack you with SHARP statements.

#>

#Building behind the scenes button

Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::YesNo
$MessageboxTitle = “Test pop-up message title”
$Messageboxbody = “Are you sure you want to stop this script execution?”
$MessageIcon = [System.Windows.MessageBoxImage]::Warning
#End behind the scenes button work

#Beginning Answers Array

$answers = @(
    "Make sure you are following documented procedure."
    "I have over four thousand emails in my inbox."
    "I cannot send you an email, I am incapable of doing so."
    "No that's not possible. (But it is like breathing air)"
    "but"
    "This needs done immediately, but don't schedule this."
    "I constantly reject reality."
    "What are you working on?"
    "<radio static>"
    "We're under a microscope right now."
    "This team has a lot of visibility right now."
    "If I assign each tech 56 more tickets we can clear the queue."
    "Unassigned is creeping up again."
    "<radio static> ... Tony."
    "I don't feel like scheduling cart cleanup is a good use of time."
    "You're doing great, but I will still fire you tomorrow."
    "We're working at 110%, but we need to be at 400%"
    "If you are in the back you are not working."
    "I can hear you guys from my office."
    "Shut up and listen to me."
    "I just just got off the phone with them."
    "I spoke to security."
    "I just came from Terry's office."
    "It's Terry's fault."
    "Don't write this down I will send an email."
    "You don't need to write this down, I will email the team."
    "I wasn't listening to you speak because you are not important."
    "I don't understand. Explain this to me."
    "The expansion of forty..."
    "Look at all these 15 minute blocks..."
    "I find it hard to believe you can't find time to..."
    "I don't feel that is an unreasonable request."
    "My decision is based off my mood."
    "Let me tell you how amazing I am..."
    "The week I started... COAS opened..."
    "I had to help mother move..."
    "Alexa, play Miley Cyrus."
    "I don't like my family."
    "I don't want to spend a lot of time on metrics."
    "I don't expect you to stay late because I do, but..."
    "Kyle is the exception to the rule."
    "Nobody can be as perfect as Kyle."
    "I worked 70 hours last week."
    "I will protect you from Terry."
    "I have my mom's dog again this week."
    "Make sure to copy how Donna notes tickets."
    "I feel I am not an effective leader anymore."
    "If you don't hear them say no, then it's consensual."
    "A deaf person can get away with anything because they can't hear you."
    "You are only useful because you write scripts..."
    "I am so sore."
    "My wife burning down our kitchen."
    "It's your birthday and there's five minutes left in your shift. Go home early."
    "I was in the top 1% of 30,000 employees."
    "I don't micromanage."
    "Do you have capacity?"
    "I went to my Tai-Chi class last night."
    "heh heh heh"
    "God-dammit TechNAME."
    "Send the %$#@^ e-mail!"
    "It's in my drafts."
    "Do you have five minutes?"
    "Can I see you in my office for a minute?"
    "Did I tell you about the truck I want to buy?"
    "Have I told you about my pool?"
    "My brother in law is lazy."
    "I was the number one tech at everywhere."
    "You are doing a great job, but here's why you still suck."
    "Do you have the cut list?"
    "You cannot leave my office, that is insubordination."
    "I need this team to run as efficiently as possible. 100% is not enough."
    "When I was in Tucson."
    "Have I told you the story of the spider jumping on my face?"
    "I won best manager award."
    "I am from Iowa."
    "Can you talk with less of an accent? It's hard to understand you."
    "Your accent is pretty thick."
    "Document that."
    "I know you are booked right now, but..."
    "I didn't look at your calendar because I do not value you as a human."
    "Verbiage, I use it incorrectly all of the time."
    "Terry called me six times to discuss this yesterday."
    "This is damage control"
    "I am going to shoot one over the bow!"
    "I can hear you cackle from down the hallway."
    "Terry is in the other room."
    "Come on, we need to raise the bar a little higher."
    "Who lowered the bar?"
)
#End Answers Array

#Building Timer this entire thing runs on. 

$timeout = new-timespan -Minutes 1
$sw = [diagnostics.stopwatch]::StartNew()

#While this timer is running, and the elapsed time is less than the timer total time... 

while ($sw.elapsed -lt $timeout){
    
    #As long as the elapsed time is greater than 0 do this... 

    if ($sw.elapsed -gt 0)
        {
        #Randomize from $answers
        $Messageboxbody = $answers | Get-Random -Count 1
        
        #Display in message box
        [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon)
        
        }
    start-sleep -seconds 5
}
 
Exit