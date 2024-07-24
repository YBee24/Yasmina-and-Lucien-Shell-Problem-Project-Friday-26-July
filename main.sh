echo "Good evening Lucien. Thank you dearly for helping me so, very much concerning the wonderful EC2 issue I had been experiencing. Let's get this project underway, eh?!"

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80

check_cpu_usage() {
  CPU_USAGE=$(ps -eo pcpu | awk 'NR>1' | awk '{sum+=$1} END {print sum}')
  echo -e "CPU Usage: $CPU_USAGE%"
  if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo -e "ALERT: CPU usage is above $CPU_THRESHOLD%"
  else
    echo -e "CPU usage is within normal range."
  fi
}

check_cpu_usage
