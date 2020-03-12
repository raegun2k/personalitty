# declare scope of the current return code and the return code buffer
export PTTYCURRC=0;



# set mood levels
export PTTYMOODS="PTTYCOOL PTTYSADNESS PTTYANGER PTTYCONFUSION";
export MOODCOUNT=$(echo $PTTYMOODS | wc -w)
for m in $(echo $PTTYMOODS); do export "$m"=0; done;
export PTTYMOOD='PTTYCOOL';

# export the personality for use in PS1, etc...
if [[ -z "$PTTY" ]]; then export PTTY='( •_•)'; fi

# converts the current mood to a face, using the 
# current strength of that mood to pick an appropriate face
function ptty_mood_to_face() {
    moodcountmedian=$(expr $MOODCOUNT / 2)
    moodval=$(printenv $1)
    mooddampen=0;
    for m in $(echo $PTTYMOODS); do if [[ $(printenv $m) -gt 0 ]]; then if [[ "$moodval" ]]; then let "moodval--"; fi; fi; done;
    case "$1" in
        PTTYCOOL) 
            if [[ "$moodval" -lt $moodcountmedian ]]; 
                then echo '( •_•)'; 
                else echo '( ^_^)'; 
            fi;;
        PTTYSADNESS) 
            if [[ "$moodval" -lt $moodcountmedian ]]; 
                then echo '( -_-)'; 
                else echo '( T.T)'; 
            fi;;
        PTTYANGER) 
            if [[ "$moodval" -lt $moodcountmedian ]]; 
                then echo '(　ﾟДﾟ)'; 
                else echo '(＃ﾟДﾟ)'; 
            fi;;
        PTTYCONFUSION) 
            if [[ "$moodval" -lt $moodcountmedian ]]; 
                then echo '( °-°)'; 
                else echo '( O_o)'; 
            fi;;
        *)
            echo '( •_•)'
         ;;
    esac
}

# this function possibly didn't need to be a function
# holdover of a previous attempt. But breaking it off
# like this could make things easier later for new functionality
function ptty_rebuffer() {
    pttytmprc=$?;
    export PTTYCURRC=$pttytmprc;
}

# we don't really want the numbers to go up endlessly, so as one
# mood gets a point, the other moods will lose one.
function ptty_normalize() {
    for m in $(echo $PTTYMOODS); do
        if [[ ("$m" != "$1") && ($(printenv ${m}) -gt 0) ]]; then 
            let "${m}--"
        fi
    done;
}

# uses the return code to generate mood and set
# the PTTY environment variable with a face
function ptty_eval_current_mood {
    ptty_rebuffer;
    pttyemoteval=$(ptty_rc2emotes "$1")
    if [[ "${pttyemoteval}" -lt "$MOODCOUNT" ]]; then let "${pttyemoteval}++"; fi;
    
    # this creates a list of the moods and their scores and inverse 
    # sorts them to get the dominant one. The sed removes the score
    # so the mood name can be used.
    export PTTYMOOD=$(for v in $(echo $PTTYMOODS); do echo "`printenv $v`$v"; done | sort --reverse | head -1 | sed 's/[0-9]//g')
    
    # normalize the values to make sure the scores don't 
    # climb endlessly
    ptty_normalize "${pttyemoteval}";
    export PTTY=$(ptty_mood_to_face "$PTTYMOOD");

}

# associates a mood to a return code
function ptty_rc2emotes() {
    case "$1" in 
     "0") # cool
      echo "PTTYCOOL"
    ;;
     "1") # General error
      echo "PTTYANGER"
    ;;
     "2") # Misuse of shell functions
      echo "PTTYANGER"
    ;;
     "126") # Cannot execute invoked command, permissions?
      echo "PTTYSADNESS"
    ;;
     "127") # Command not found
      echo "PTTYCONFUSION"
    ;;
     "128") # Invalid argument to exit
      echo "PTTYANGER"
    ;;
    "130") # Interrupted
      echo "PTTYANGER" #placeholder
    ;;
    *) # cool
      echo "PTTYCONFUSION" # I'unno
    ;;
    esac
}

# this should be called by the shell RC before every new command.
function ptty_eval() {
    ptty_eval_current_mood $?;
}


