#!/bin/bash
# should be sourced from $HOME/.bashrc

vpn() {
  case $1 in
    u*|on)
      if [[ "$(vpn st)" == "No vpn process running!" ]]; then
        sudo -nb bash -c "
echo \$$ > \"$HOME/.vpn/pid\"
trap \"rm -f $HOME/.vpn/pid\" INT QUIT TERM
exec /usr/sbin/openvpn \"$HOME/.vpn/config/wagnerHamptonVPN2017.ovpn\" > \"$HOME/.vpn/log\" 2>&1
"
      else
        echo "VPN already running!"
        vpn st
      fi
    ;;
    of*|h*|d*)
      if [[ -f "$HOME/.vpn/pid" ]]; then
          sudo kill "$(cat "$HOME/.vpn/pid")"
          rm -f "$HOME/.vpn/pid" "$HOME/.vpn/log"
      else
        echo "No vpn process running!"
      fi
    ;;
    st*|ch*)
      if [[ -f "$HOME/.vpn/pid" ]] && sudo kill -0 "$(cat "$HOME/.vpn/pid")"; then
        echo "VPN running with PID $(cat "$HOME/.vpn/pid")"
        echo "Last 5 lines of the log:"
        tail -5 "$HOME/.vpn/log"
        return 0
      else
        echo "No vpn process running!"
        return 1
      fi
    ;;
    *)
      echo "Usage: vpn <up/down/status>"
    ;;
  esac
}


