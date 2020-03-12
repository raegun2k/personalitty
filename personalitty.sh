# declare scope of the current return code and the return code buffer
export PTTYCURRC=0;



# set mood levels
export PTTYMOODS="PTTYCOOL PTTYSADNESS PTTYANGER PTTYCONFUSION";
export MOODCOUNT=$(echo $PTTYMOODS | wc -w)
for m in $(echo $PTTYMOODS); do export "$m"=0; done;
export PTTYMOOD='PTTYCOOL';

# export the personality for use in PS1, etc...
if [[ -z "$PTTY" ]]; then export PTTY='( •_•)'; fi

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


function ptty_rebuffer() {
    pttytmprc=$?;
    export PTTYCURRC=$pttytmprc;
}

function ptty_normalize() {
    for m in $(echo $PTTYMOODS); do
        if [[ ("$m" != "$1") && ($(printenv ${m}) -gt 0) ]]; then 
            let "${m}--"
        fi
    done;
}

function ptty_eval_current_mood {
    ptty_rebuffer;
    pttyemoteval=$(ptty_rc2emotes "$1")
    if [[ "${pttyemoteval}" -lt "$MOODCOUNT" ]]; then let "${pttyemoteval}++"; fi;
    # set "$pttyemoteval"=$(expr $(echo "$pttyemoteval") + 1);
    export PTTYMOOD=$(for v in $(echo $PTTYMOODS); do echo "`printenv $v`$v"; done | sort --reverse | head -1 | sed 's/[0-9]//g')
    #echo ADD "$PTTYMOOD"=$(expr "$(printenv $PTTYMOOD) + 1");
    #let "${PTTYMOOD}++"
    ptty_normalize "${pttyemoteval}";
    export PTTY=$(ptty_mood_to_face "$PTTYMOOD");

}


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

function ptty_eval() {
    ptty_eval_current_mood $?;
}


