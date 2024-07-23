# Yasmina-and-Lucien-Shell-Problem-Project-Friday-26-July

# Analyze and Summarize System Logs


## User Story

1. As a system administrator, I want to input directory path containing log file to analyze multiple system log files
2. The script scans each log file in the directory for predefined keywords ("error", "warning", "fail").
3. The script extracts and formats the relevant information (timestamps, messages) for each occurrence of the keywords.
4. The tool should generate a summary report that includes timestamps and relevant messages, which will help me quickly identify and address system issues.
5. The script outputs the summary report to the console and optionally saves it to a specified file.



Given: A directory /var/logs/ containing multiple log files (syslog, auth.log, dnf.log).
When: I run the script with the command ./log_analyzer.sh /var/logs/.
Then: The script scans all the log files in the /var/logs/ directory for the keywords "error", "warning", and "fail".
And: The script generates a summary report that includes:
The filename and path of each log file analyzed.
The occurrences of each keyword with timestamps and messages.
And: The summary report is displayed on the console and saved to log_summary.txt.
