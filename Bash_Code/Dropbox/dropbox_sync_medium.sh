#!/bin/bash

#Username
SSH_USER="myuser"

#Set the directory mappings for what servers and directories you want to sync PULL
declare -A DIR_MAP=(
  ["site1-ServerA:/dropbox/OUT/<dest-site2-name>"]="/dropbox/<dest-site2-name>"
  ["site1-ServerA:/dropbox/OUT/<dest-site3-name>"]="/dropbox/<dest-site3-name>"
  ["site2-ServerA:/dropbox/OUT/<dest-site1-name>"]="/dropbox/<dest-site1-name>"
  ["site2-ServerA:/dropbox/OUT/<dest-site3-name>"]="/dropbox/<dest-site3-name>"
  ["site3-ServerA:/dropbox/OUT/<dest-site1-name>"]="/dropbox/<dest-site1-name>"
  ["site3-ServerA:/dropbox/OUT/<dest-site2-name>"]="/dropbox/<dest-site2-name>"
)

for SRC in "${!DIR_MAP[@]}"; do
  DEST="${DIR_MAP[$SRC]}"

  echo "PULL Syncing $SRC → $DEST"

  OUTPUT=$(rsync -az \
    --remove-source-files \
    --out-format="%n" \
    --min-size=10G \
    --max-size=100G \
    -e ssh \
    "${SSH_USER}@${SRC}" \
    "$DEST")

  if [[ -z "$OUTPUT" ]]; then
    echo "No new files."
  else
    echo "Moved files:"
    echo "$OUTPUT"
  fi

  echo "-----------------------------"
done



#Set the directory mappings for what servers and directories you want to sync PUSH
declare -A DIR_MAP=(
  ["/dropbox/<dest-site1-name>"]="<site1-ServerA>:/dropbox/IN"
  ["/dropbox/<dest-site2-name>"]="<site2-ServerA>:/dropbox/IN"
  ["/dropbox/<dest-site3-name>"]="<site3-ServerA>:/dropbox/IN"
)

for SRC in "${!DIR_MAP[@]}"; do
  DEST="${DIR_MAP[$SRC]}"

  echo "PUSH Syncing $SRC → $DEST"

  OUTPUT=$(rsync -az \
    --remove-source-files \
    --out-format="%n" \
    --min-size=100G \
    -e ssh \
    "$SRC" \
    "${SSH_USER}@${DEST}")

  
  #Check to see if the directory is empty, if so do nothing
  if [[ -z "$OUTPUT" ]]; then
    echo "No new files."
  else
    echo "Moved files:"
    echo "$OUTPUT"
  fi

  echo "--------------END--------------"
done