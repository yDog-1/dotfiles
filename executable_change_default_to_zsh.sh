
#!/bin/bash
# デフォルトシェルをzshに変更するスクリプト
set -e

echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
