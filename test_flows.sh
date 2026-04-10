#!/bin/bash
BASE_URL="http://localhost:8080/SmartPlacement"

check_status() {
    if [ "$1" -eq 200 ]; then
        echo -e "\e[32mPASS: $2 [Status: $1]\e[0m"
    elif [ "$1" -eq 302 ]; then
        echo -e "\e[34mREDIRECT: $2 [Status: $1]\e[0m"
    else
        echo -e "\e[31mFAIL: $2 [Status: $1]\e[0m"
        # If it's 500, let's show the error message from the body
        if [ "$1" -eq 500 ]; then
             echo "Error Details:"
             curl -s -b cookies.txt "$3" | grep -o 'Message.*' | sed 's/<[^>]*>//g'
        fi
    fi
}

echo "--- System Verification ---"

# 1. Student Module
echo -e "\n[Student Module]"
rm -f cookies.txt
curl -s -c cookies.txt -d "role=student&email=arjun@student.com&password=student123" "$BASE_URL/login" > /dev/null
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -b cookies.txt "$BASE_URL/studentDashboard")
check_status "$STATUS" "Student Dashboard" "$BASE_URL/studentDashboard"

# 2. Admin Module
echo -e "\n[Admin Module]"
rm -f cookies.txt
curl -s -c cookies.txt -d "role=admin&email=admin&password=admin123" "$BASE_URL/login" > /dev/null
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -b cookies.txt "$BASE_URL/adminDashboard")
check_status "$STATUS" "Admin Dashboard" "$BASE_URL/adminDashboard"

# 3. Company Module
echo -e "\n[Company Module]"
rm -f cookies.txt
# Using known credentials from DB - Targeting the new CompanyLoginServlet
curl -s -c cookies.txt -d "role=company&email=hr@infosys.com&password=infosys123" "$BASE_URL/CompanyLoginServlet" > /dev/null
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -b cookies.txt "$BASE_URL/companyDashboard")
check_status "$STATUS" "Company Dashboard (hr@infosys.com via CompanyLoginServlet)" "$BASE_URL/companyDashboard"
