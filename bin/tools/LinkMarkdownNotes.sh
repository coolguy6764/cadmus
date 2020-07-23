#!/usr/bin/env bash
    readonly script_name=$(basename "${0}")
if [ "$1" == "-h" ] || [ "$1" == "--help"  ]; then

    echo " ${script_name} /path/to/dir input-file"
    echo "I should probably handle arguments more elegantly"
    exit 0

elif [[ $1 != '' ]]; then
    NOTES_DIR=$1
else
    NOTES_DIR='./'
fi

cd "${NOTES_DIR}"

main() {



 OUTPUTFILE=$(getNote_onlyShowFileName)
 INPUTFILE="${2}"

REL_PATH=$(realpath --relative-to $(dirname $INPUTFILE) $OUTPUTFILE)
## echo $REL_PATH | xclip -selection clipboard
##

echo $(MarkdownLink)

## TODO The Relative Path is in-FUCKING-correct


}


MarkdownLink() {

    name=$(basename $REL_PATH  | cut -f 1 -d '.')
    echo "[$name](./$REL_PATH)"
}

getNote() {
    fd \.md | sk \
   --preview "mdcat {}" \
   --bind pgup:preview-page-up,pgdn:preview-page-down
}



  ## This version only displays the file name, which is better for small
  ## displays
  ##
      ## (although you loose context with regard to the directories which I
      ## treat as notebooks)
  ##
  ## This relies on the fact that each note has a unique name
  ## If you've symlinked notes into two places you're a bad person
  ## and it's your own fault that this has got you into hot water.
  ##
getNote_onlyShowFileName() {

# command -v sk >/dev/null 2>&1 || { echo >&2 "I require skim but it's not installed. install it from https://github.com/lotabout/skim, aborting ."; exit 1; }
 command -v fzf >/dev/null 2>&1 || { echo >&2 "I require but it's not installed. install it from https://github.com/junegunn/fzf, aborting ."; exit 1; }
 command -v fd >/dev/null 2>&1 || { echo >&2 "I require but it's not installed. install it with ~cargo install fd~, aborting ."; exit 1; }

    fd \.md | sd '^' 'basename "' | sd '$' '"' | bash | \
        fzf --preview "fd {} | xargs mdcat" \
        --bind pgup:preview-page-up,pgdn:preview-page-down | \
        xargs fd | xargs realpath


}

main "${@}"
