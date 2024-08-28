# Set up socket location
shared_path = "/home/deployer/shopex/shared"
release_path = "/home/deployer/shopex/current"

bind "unix://#{shared_path}/tmp/sockets/shopex-puma.sock"

# Logging
stdout_redirect "#{release_path}/log/pumapd.stdout.log", "#{release_path}/log/pumapd.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_path}/tmp/pids/puma.pid"
state_path "#{shared_path}/tmp/pids/puma.state"

activate_control_app