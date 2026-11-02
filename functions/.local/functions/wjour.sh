#!/usr/bin/env bash

JOURNAL_PATH='/home/asajaroff/Workspace/journal.md'

function wjour() {
    args=("$@")

    case ${args[0]} in
        'new')
            echo "Creating new entry"
	    echo
	    cat << EOL >> ${JOURNAL_PATH}
---

# $(date --iso-8601) $(date +%A)
Fact of the day:

Description about the day.

## Tasks

- [Certs](https://eagleeyenetworks.atlassian.net/browse/INFRA2-9660)

### task1 [ 'dealer-tls', 'cm-global-cluster', 'webapp-tls' ]
link: [Certs](https://eagleeyenetworks.atlassian.net/browse/INFRA2-9660)

### task2

link: [INFRA2-9660](https://eagleeyenetworks.atlassian.net/browse/INFRA2-9660)

EOL
            nohup gnome-text-editor "${JOURNAL_PATH}" --new-window > /dev/null 2>&1 &
            ;;
        'open')
            echo "Opening work journal"
            nohup gnome-text-editor "${JOURNAL_PATH}" --new-window > /dev/null 2>&1 &
            ;;
        'add')
            echo "Adding to entry"
            ;;
        *)
	    printf "Usage:\t%s [OPTS] [VERB]\n" $0

            printf "Valid commands:\n\tnew\tCreates a new entry in the work journal"
	    printf "\n\topen\tOpens the text editor with the Work journal"
	    printf "\n\tgoto\tGoes to the selected date"


            # echo "Unknown command: ${args[0]}"
            ;;
    esac
}
