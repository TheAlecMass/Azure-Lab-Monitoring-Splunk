Admin account needs to be called 'dbs_admin'
SSH into lan as dbs_admin

Run the following commands:
sudo su -
cd /home/dbs_admin
nano setup_qut_log_forwarder.sh -> Paste set-up script contents
chmod +x /home/dbs_admin/setup_qut_log_forwarder.sh
./setup_qut_log_forwarder.sh
 