
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


PS3="Please select an option: "
options=("All Reports" "Memory Usage" "CPU Usage" "Top CPU Processes" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "All Reports")
      generate_report
      ;;
    "Memory Usage")
      check_memory_usage
      ;;
    "CPU Usage")
      check_cpu_usage
      ;;
    "Top CPU Processes")
      top_cpu_processes
      ;;
    "Quit")
      break
      ;;
    *) echo "Invalid option $REPLY";;
  esac

 echo -e "\nWould you like to download the report? (yes/no)"
  read download_report
  if [[ $download_report == "yes" ]]; then
    generate_report
    echo -e "${GREEN}Downloading the report...${NC}"
    cp report.txt /path/to/your/desired/location/
    echo -e "${GREEN}Report downloaded to /path/to/your/desired/location/report.txt${NC}"
  else
    echo -e "${YELLOW}Report not downloaded.${NC}"
  fi

  echo -e "\nThank you! Exiting the module.\n"
  break
done



