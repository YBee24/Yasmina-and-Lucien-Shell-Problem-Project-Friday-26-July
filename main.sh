
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_cpu_usage() {
  CPU_USAGE=$(ps -eo pcpu | awk 'NR>1' | awk '{sum+=$1} END {print sum}')
  echo -e "CPU Usage: ${YELLOW}$CPU_USAGE%${NC}"
  if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo -e "${RED}ALERT: CPU usage is above $CPU_THRESHOLD%${NC}"
  else
    echo -e "${GREEN}CPU usage is within normal range.${NC}"
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




generate_report() {
  echo "Generating report..."
  
  echo -e "${YELLOW}System Monitoring Report - $(date)${NC}"
  echo "----------------------------------"
  check_cpu_usage
  echo "----------------------------------"
  top_cpu_processes
  echo "----------------------------------"
  check_memory_usage
  echo "----------------------------------"
  top_memory_processes
  echo "----------------------------------"
  check_disk_usage
  echo "----------------------------------"
  
  
  
  
  REPORT="report.txt"
  {
    check_cpu_usage
    check_memory_usage
    top_cpu_processes
  } > $REPORT
  echo -e "${GREEN}Report generated: $REPORT${NC}"
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
  DESKTOP_DIR="$HOME/Desktop"
      DOWNLOADS_DIR="$HOME/Downloads"
      
      if [ -d "$DESKTOP_DIR" ]; then
        cp report.txt "$DESKTOP_DIR/report.txt"
        echo -e "${GREEN}Report downloaded to $DESKTOP_DIR/report.txt${NC}"
      else
        cp report.txt "$DOWNLOADS_DIR/report.txt"
        echo -e "${GREEN}Desktop directory not found. Report downloaded to $DOWNLOADS_DIR/report.txt${NC}"
      fi
  else
    echo -e "${YELLOW}Report not downloaded.${NC}"
  fi

  echo -e "\nThank you! Exiting the module.\n"
  break
done



