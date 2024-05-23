#!/bin/bash

echo "<table>"
echo "  <tr>"
echo "    <th>Username</th>"
echo "    <th>Group</th>"
echo "    <th>Login Shell</th>"
echo "    <th>GECOS</th>"
echo "  </tr>"

awk -F: '{print "  <tr>\n    <td>" $1 "</td>\n    <td>" $3 "</td>\n    <td>" $7 "</td>\n    <td>" $5 "</td>\n  </tr>"}' /etc/passwd

echo "</table>"
