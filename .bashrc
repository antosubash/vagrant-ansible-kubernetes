
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
export PATH=~/.krew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
