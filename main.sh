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


check_memory_usage() {
  MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  TOTAL_MEMORY=$(free -m | grep Mem | awk '{print $2}')
  USED_MEMORY=$(free -m | grep Mem | awk '{print $3}')
  echo -e "Memory Usage: ${YELLOW}$MEMORY_USAGE%${NC}"
  echo -e "Total Memory: ${YELLOW}${TOTAL_MEMORY}MB${NC}"
  echo -e "Used Memory: ${YELLOW}${USED_MEMORY}MB${NC}"
  if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo -e "${RED}ALERT: Memory usage is above $MEMORY_THRESHOLD%${NC}"
  else
    echo -e "${GREEN}Memory usage is within normal range.${NC}"
  fi
}


top_cpu_processes() {
  echo -e "${YELLOW}Top 3 CPU consuming processes:${NC}"
  ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 4 | tail -n 3 | awk '{print $1 " " $2 " " $3 " " $4 "%"}'
}


check_cpu_usage
check_memory_usage
top_cpu_processes
