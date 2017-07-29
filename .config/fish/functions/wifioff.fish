function wifioff --description "Turnoff apple wifi"
  wifi=`networksetup -listallhardwareports | grep -A1 Wi-Fi | awk '{print $2}' | tail -n1`
  networksetup -setairportpower $wifi off
end

