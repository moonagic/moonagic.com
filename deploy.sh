# 移除旧的发布文件
bundle exec jekyll clean
# 生成新的发布文件
bundle exec jekyll build
# 删除不必要的文件
rm _site/deploy.sh
rm _site/README.md
# 上传
scp -r -P 2222 _site/* root@47.52.44.233:/home/jekyll2
