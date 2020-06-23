#!/bin/bash

##### Package Manger #########
if [ -n "$(command -v yum)" ] ; then
		installer='yum'
    elif  [ -n "$(command -v apt)" ] ; then
        installer='apt'
    else
        installer='brew'
fi
echo "Package manager is" $installer

####### Download packages #########
sudo $installer -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo $installer -y update
sudo $installer -y install python37 htop git gcc gcc-c++ autoconf\
                           automake libevent libevent-devel ncurses-devel\
			   zsh autojump-zsh util-linux-user fzf

####### Python3 packages #########
pip='pip-3.7'
sudo $pip install -U scipy numpy jupyter pandas tensorflow keras sklearn gensim boto3 wheel pip torch jupyterlab dvc

####### Modern Tmux with package management #########
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install
cd ..

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cat <<EOF >> .tmux.conf
set-option -g mouse on
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @plugin 'tmux-plugins/tmux-logging'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

# Vim style pane selection
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

set-option -g history-limit 5000000

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF
tmux source .tmux.conf



####### ZSH + Oh my ZSH #########
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sed -i "s/  git/  sudo git autojump docker tmux common-aliases pip python yum zsh-autosuggestions zsh-syntax-highlighting/" .zshrc 
sed -i "s/ZSH_THEME.*/ZSH_THEME=\"zhann\"/" .zshrc 

sudo chsh -s /bin/zsh ec2-user

####### Done #######
echo "Done! Please logout and login to enjoy your new system."
