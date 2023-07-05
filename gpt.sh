#!/bin/bash
echo "     __________  ______"
echo "    / ____/ __ \/_  __/"
echo "   / / __/ /_/ / / /"
echo "  / /_/ / ____/ / /"
echo "  \____/_/     /_/"
echo "  "                                      

API_KEY="sk-"

while true; do
  echo ""
  read -r -p "Enter your question: " prompt
  API_ENDPOINT="https://api.openai.com/v1/chat/completions"
  spinner_pid=''
  {
    while :; do
      for s in / - \\ \|; do
        printf "\r$s"
        sleep .1
      done
    done
  } &
  spinner_pid=$!
  response=$(curl -s -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d '{
       "model": "gpt-3.5-turbo",
       "messages": [{"role": "user", "content": "'"$prompt"'"}],
       "temperature": 0.7
     }' "$API_ENDPOINT")
  kill "$spinner_pid" >/dev/null 2>&1
  printf "\r%s\r" " "
  answer=$(printf "%s\n" "$response" | jq -R '.' | jq -s '.' | jq -r 'join("")' | jq -r '.choices[0].message.content') 
  echo ""
  echo "\033[0;96m $answer \033[0m" 
  notify-send "GPT" "$answer"
done

