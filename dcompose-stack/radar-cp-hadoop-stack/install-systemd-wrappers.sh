#!/bin/bash

. ./util.sh

check_command_exists systemctl

copy_template_if_absent /etc/systemd/system/radar-docker.service lib/systemd/radar-docker.service.template
copy_template_if_absent /etc/systemd/system/radar-output.service lib/systemd/radar-output.service.template
copy_template_if_absent /etc/systemd/system/radar-output.timer lib/systemd/radar-output.timer.template

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

inline_variable 'WorkingDirectory=' "$DIR" /etc/systemd/system/radar-docker.service
inline_variable 'ExecStart=' "$DIR/lib/systemd/start-radar-stack.sh" /etc/systemd/system/radar-docker.service

inline_variable 'WorkingDirectory=' "$DIR" /etc/systemd/system/radar-output.service
inline_variable 'ExecStart=' "$DIR/hdfs_restructure.sh /topicAndroidNew output" /etc/systemd/system/radar-output.service

sudo systemctl daemon-reload
sudo systemctl enable radar-docker
sudo systemctl enable radar-output.timer
sudo systemctl start radar-docker