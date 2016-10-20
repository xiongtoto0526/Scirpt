#!/bin/bash
cd /var/lib/xionghaitao
vi .bashrc

# add some alias
alias log-xht-excel='tail -f /var/lib/xionghaitao/workspace/run/logs/excel.log'
alias log-xht='tail -f /var/lib/xionghaitao/workspace/run/log/all.log'
# add some alias

source .bashrc


