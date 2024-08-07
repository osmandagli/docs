#!/bin/bash

first_document_id=$1
second_document_id=$2

readonly COMMAND_FAILED="150"

echo -e "First document id is $first_document_id\n"

echo -e "Second document id is $second_document_id"

terminate() {
        local -r msg='${1}'
        local -r code="${2:-150}"
        echo "${msg}" >&2
        exit "${code}"
}

first_pdf_url=$(curl -sS -X GET "xxxxxxx"  | python -m json.tool | grep -e "ACS/" |awk '{print $2}' | uniq | tr -d '"' | tr -d ',')

if [ $? -ne 0 ]; then
    terminate "First document's rest command was not successfull" $?
fi

second_pdf_url=$(curl -sS -X GET "xxxxxxx" | python -m json.tool | grep -e "ACS/" |awk '{print $2}' | uniq | tr -d '"' | tr -d ',')

if [ $? -ne 0 ]; then
    terminate "Second document's rest command was not successfull" $?
fi

first_pdf_url=${first_pdf_url:38}

second_pdf_url=${second_pdf_url:38}

first_pdf_url="xxxxxxx${first_pdf_url}"

second_pdf_url="xxxxxxx${second_pdf_url}"

wget "${first_pdf_url}" -O ${first_document_id}.pdf --no-check-certificate > /dev/null 2>&1

if [ $? -ne 0 ]; then
    terminate "First document's pdf extraction was NOT successfull" $?
fi

wget "${second_pdf_url}" -O ${second_document_id}.pdf --no-check-certificate > /dev/null 2>&1

if [ $? -ne 0 ]; then
    terminate "Second document's pdf extraction was NOT successfull" $?
fi

pdftotext -layout ${first_document_id}.pdf ${first_document_id}.txt

pdftotext -layout ${second_document_id}.pdf ${second_document_id}.txt

vimdiff ${first_document_id}.txt ${second_document_id}.txt -c 'set diffopt-=internal' -c 'set diffopt+=iwhite' -c TOhtml -c "w! ${first_document_id}-${second_document_id}.html" -c 'qa!'
