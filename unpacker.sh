#!/bin/bash

echo "Unpacker started"

VERBOSE=false

while getopts ":v" flag; do
case "${flag}" in
    v)
        VERBOSE=true;
        echo "verbose ON"
esac
done

promptContinue() {
    read -p "Do you want to continue? (Y/N) :" CONTINUE_ANSWER

        if [ "$CONTINUE_ANSWER" == "Y" ] || [ "$CONTINUE_ANSWER" == "y" ]
        then
            INPUT_SOURCE="$(dirname -- "$INPUT_SOURCE")"
            echo "Accepted source location: $INPUT_SOURCE"
        elif [ "$CONTINUE_ANSWER" == "N" ] || [ "$CONTINUE_ANSWER" == "n" ]
        then
            echo "DeOrganiser will be exited."
            exit
        else
            echo "'$CONTINUE_ANSWER' is not a viable answer. Please answer the question again."
            promptContinue
        fi
}

promptSource() {
    read -p "Source folder location: " INPUT_SOURCE

    if [ -z "$INPUT_SOURCE" ] 
    then
        echo "WARNING: No source path input, please fill in a source location"
        promptSource
    elif [ -f "$INPUT_SOURCE" ]
    then
        echo "WARNING: Source path leads to a file."
        echo "The folder containing the file will be taken as source folder"
        promptContinue
    elif [ ! -d "$INPUT_SOURCE" ] && [ ! -f "$INPUT_SOURCE" ]
    then
        echo "'$INPUT_SOURCE' is not a valid location, please fill in a valid source location"
        promptSource
    fi
}

promptDestination() {   
    read -p "Destination folder location: " INPUT_DESTINATION

    if [ -z "$INPUT_DESTINATION" ] 
    then
        echo "WARNING: No destination path input, please fill in a source location"
        promptDestination
    elif [ -f "$INPUT_DESTINATION" ]
    then
        echo "WARNING: DESTINATION path leads to a file."
        echo "The folder containing the file will be taken as source folder"
        promptContinue
    elif [ ! -d "$INPUT_DESTINATION" ] && [ ! -f "$INPUT_DESTINATION" ]
    then
        echo "'$INPUT_DESTINATION' is not a valid location, please fill in a valid destination location"
        promptDestination
    fi
}

setLocations() { # INPUT1 = SOURCE | INPUT2 = DESTINATION
    SOURCE=$1
    DESTINATION=$2

    if $VERBOSE
    then
        echo "Source set to: $SOURCE"
        echo "Destination set to: $DESTINATION"
    fi
}

getTotalFiles() {
    NUM_FILES=0;
    countFiles() {
    for i in $1*; 
    do  
        if [ -d $i ]
        then
            DIRECTORY="$i/" # Append / for correct handling
            countFiles $DIRECTORY
        else
            NUM_FILES=$((NUM_FILES+1))
        fi
    done
    }
    countFiles $1
}
trackProgress() {
    NUM_COPIED=$((NUM_COPIED+1))
    if [ "$NUM_COPIED" == "$NUM_FILES" ]
    then
        echo -ne "Progress: $NUM_COPIED / $NUM_FILES \r\c"
        echo -ne "\n"
        echo "DONE"
    else
        if $VERBOSE
        then
            echo "Progress: $NUM_COPIED / $NUM_FILES"
        else
            echo -ne "Progress: $NUM_COPIED / $NUM_FILES \r\c"
        fi
    fi
    
}

copyDirectory() { # INPUT1 = SOURCE | INPUT2 = DESTINATION
    for i in $1*; 
    do  
        if [ -d $i ]
        then
            if $VERBOSE
            then
                echo "Iterating over folder, Diving deeper"
            fi

            DIRECTORY="$i/" # Append / for correct handling
            copyDirectory $DIRECTORY
        else
            if $VERBOSE
            then
            echo "Cloning file: $i "
            echo "To destination: $DESTINATION "
            fi

            cp $i $DESTINATION
            trackProgress
        fi
    done
}

promptSource
promptDestination
setLocations $INPUT_SOURCE $INPUT_DESTINATION

getTotalFiles $SOURCE

copyDirectory $SOURCE $DESTINATION




