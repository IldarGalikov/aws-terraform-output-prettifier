#/bin/bash

main() {

  while getopts "h:" Option
  do
    case $Option in
      h     ) printHelp;;
      *     ) printHelp;;
    esac
  done

  NC='\033[0m' # No Color
  lastVariableName=""

  while read CMD; do

    line=$CMD
    [[ $line =~ ^.*module.*$ ]] && echo $line &&  printf "${NC}"
    if [[ $line =~ ^.*\.[0-9]+\.name:.*$ ]]
    then
      first=$(echo $line | cut -d '"' -f 2 | sed "s/\"//g")
      second=$(echo $line | cut -d '"' -f 4 | sed "s/\"//g")

      if [[ $first == "" ]]
      then
        lastVariableName="Adding new variable '$second'"
      else
        lastVariableName="Removing variable '$first'"
      fi

    fi
    if [[ $line =~ "value" ]]
    then
      value1=$(echo $line | sed -E 's/.*"(.*)" =>.*/\1/g')
      value2=$(echo $line | sed -E 's/.* => "(.*)".*/\1/g')

      [[ $value1 != $value2 ]] && echo "$lastVariableName change values: '$value1' => '$value2'"
    fi

  done
}

printHelp() {
  echo
  echo -e  "This script would beautify terraform output"
  echo -e
  echo "Example:"
  echo "terraform plan | ./printChanges.sh "
  exit 0
}


main "$@"; exit
